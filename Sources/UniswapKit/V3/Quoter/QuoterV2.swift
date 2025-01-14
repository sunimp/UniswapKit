//
//  QuoterV2.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import Alamofire
import BigInt
import EVMKit
import SWToolKit

// MARK: - QuoterV2

public class QuoterV2 {
    // MARK: Properties

    private let networkManager: NetworkManager
    private let tokenFactory: TokenFactory
    private let dexType: DEXType

    private let fees: [KitV3.FeeAmount]

    // MARK: Lifecycle

    init(networkManager: NetworkManager, tokenFactory: TokenFactory, dexType: DEXType) {
        self.networkManager = networkManager
        self.tokenFactory = tokenFactory
        self.dexType = dexType

        fees = KitV3.FeeAmount.sorted(dexType: dexType)
    }

    // MARK: Functions

    func bestTrade(
        rpcSource: RpcSource,
        chain: Chain,
        tradeType: TradeType,
        tokenIn: Token,
        tokenOut: Token,
        amount: BigUInt
    ) async throws
        -> TradeV3 {
        do {
            switch tradeType {
            case .exactIn: return try await bestTradeSingleIn(
                    rpcSource: rpcSource,
                    chain: chain,
                    tokenIn: tokenIn,
                    tokenOut: tokenOut,
                    amountIn: amount
                )

            case .exactOut: return try await bestTradeSingleOut(
                    rpcSource: rpcSource,
                    chain: chain,
                    tokenIn: tokenIn,
                    tokenOut: tokenOut,
                    amountOut: amount
                )
            }
        } catch {
            guard case .tradeNotFound = error as? KitV3.TradeError
            else { // ignore 'not found' error, try found other trade
                throw error
            }
        }
        do {
            switch tradeType {
            case .exactIn: return try await bestTradeMultihopIn(
                    rpcSource: rpcSource,
                    chain: chain,
                    tokenIn: tokenIn,
                    tokenOut: tokenOut,
                    amountIn: amount
                )

            case .exactOut: return try await bestTradeMultihopOut(
                    rpcSource: rpcSource,
                    chain: chain,
                    tokenIn: tokenIn,
                    tokenOut: tokenOut,
                    amountOut: amount
                )
            }
        } catch {
            throw error
        }
    }

    private func correctedX96Price(sqrtPriceX96: BigUInt, tokenIn: Token, tokenOut: Token) -> Decimal? {
        let reverted = tokenIn.address.hex >= tokenOut.address.hex

        let shift = (tokenIn.decimals - tokenOut.decimals) * (reverted ? -1 : 1)
        guard let price = PriceImpactHelper.price(from: sqrtPriceX96, shift: shift) else {
            return nil
        }

        if reverted {
            return 1 / price
        }
        return price
    }

    private func quoteExact(
        rpcSource: RpcSource,
        chain: Chain,
        tradeType: TradeType,
        tokenIn: Address,
        tokenOut: Address,
        amount: BigUInt,
        fee: KitV3.FeeAmount
    ) async throws
        -> QuoteExactSingleResponse {
        let method = tradeType == .exactIn
            ? QuoteExactInputSingleMethod(
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                amountIn: amount,
                sqrtPriceLimitX96: 0
            )
            : QuoteExactOutputSingleMethod(
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                amountOut: amount,
                sqrtPriceLimitX96: 0
            )

        do {
            let data = try await call(rpcSource: rpcSource, chain: chain, data: method.encodedABI())
            guard let response = QuoteExactSingleResponse(data: data) else {
                throw KitV3.TradeError.tradeNotFound
            }

            return response
        } catch {
            if error.isExplicitlyCancelled { // throw cancellation for stop requests
                throw error
            }

            throw KitV3.TradeError.tradeNotFound
        }
    }

    private func quote(
        rpcSource: RpcSource,
        chain: Chain,
        swapPath: SwapPath,
        tradeType: TradeType,
        amount: BigUInt
    ) async throws
        -> BigUInt {
        let method = tradeType == .exactIn
            ? QuoteExactInputMethod(swapPath: swapPath, amountIn: amount)
            : QuoteExactOutputMethod(swapPath: swapPath, amountOut: amount)

        let data = try await call(rpcSource: rpcSource, chain: chain, data: method.encodedABI())
        guard data.count >= 32 else {
            throw KitV3.TradeError.tradeNotFound
        }

        return BigUInt(data[0 ... 31])
    }

    private func bestTradeExact(
        rpcSource: RpcSource,
        chain: Chain,
        tradeType: TradeType,
        tokenIn: Token,
        tokenOut: Token,
        amount: BigUInt
    ) async throws
        -> (fee: KitV3.FeeAmount, response: QuoteExactSingleResponse) {
        // check all fees and found the best amount for trade.
        var bestTrade: (fee: KitV3.FeeAmount, response: QuoteExactSingleResponse)?
        for fee in fees {
            do {
                let response = try await quoteExact(
                    rpcSource: rpcSource,
                    chain: chain,
                    tradeType: tradeType,
                    tokenIn: tokenIn.address,
                    tokenOut: tokenOut.address,
                    amount: amount,
                    fee: fee
                )
                // For exactIn - we must found the highest amountOut, for exactOut - smallest amountIn
                if
                    let bestTrade, tradeType == .exactIn
                    ? bestTrade.response.amount >= response.amount
                    : bestTrade.response.amount <= response.amount {
                    continue
                }

                bestTrade = (fee: fee, response: response)
            } catch {
                if case .tradeNotFound = error as? KitV3.TradeError {
                    continue
                }
                throw error
            }
        }

        guard let bestTrade else {
            throw KitV3.TradeError.tradeNotFound
        }

        return bestTrade
    }

    private func bestTradeSingleIn(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountIn: BigUInt
    ) async throws
        -> TradeV3 {
        let bestTradeOut = try await bestTradeExact(
            rpcSource: rpcSource,
            chain: chain,
            tradeType: .exactIn,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amount: amountIn
        )

        let pool = try await Pool(
            networkManager: networkManager,
            rpcSource: rpcSource,
            chain: chain,
            token0: tokenIn.address,
            token1: tokenOut.address,
            fee: bestTradeOut.fee,
            dexType: dexType
        )
        let sqrtPriceX96 = try await pool.slot0().sqrtPriceX96
        let slotPrice = correctedX96Price(
            sqrtPriceX96: sqrtPriceX96,
            tokenIn: tokenIn,
            tokenOut: tokenOut
        )

        let swapPath = SwapPath([SwapPathItem(
            token1: tokenIn.address,
            token2: tokenOut.address,
            fee: bestTradeOut.fee
        )])
        return TradeV3(
            tradeType: .exactIn,
            swapPath: swapPath,
            amountIn: amountIn,
            amountOut: bestTradeOut.response.amount,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            slotPrices: slotPrice.map { [$0] } ?? []
        )
    }

    private func bestTradeSingleOut(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountOut: BigUInt
    ) async throws
        -> TradeV3 {
        let bestTradeIn = try await bestTradeExact(
            rpcSource: rpcSource,
            chain: chain,
            tradeType: .exactOut,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amount: amountOut
        )

        let pool = try await Pool(
            networkManager: networkManager,
            rpcSource: rpcSource,
            chain: chain,
            token0: tokenIn.address,
            token1: tokenOut.address,
            fee: bestTradeIn.fee,
            dexType: dexType
        )
        let sqrtPriceX96 = try await pool.slot0().sqrtPriceX96
        let slotPrice = correctedX96Price(
            sqrtPriceX96: sqrtPriceX96,
            tokenIn: tokenIn,
            tokenOut: tokenOut
        )

        let swapPath = SwapPath([SwapPathItem(token1: tokenOut.address, token2: tokenIn.address, fee: bestTradeIn.fee)])
        return TradeV3(
            tradeType: .exactOut,
            swapPath: swapPath,
            amountIn: bestTradeIn.response.amount,
            amountOut: amountOut,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            slotPrices: slotPrice.map { [$0] } ?? []
        )
    }

    private func bestTradeMultihopIn(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountIn: BigUInt
    ) async throws
        -> TradeV3 {
        let weth = try tokenFactory.etherToken(chain: chain)

        let trade1 = try await bestTradeSingleIn(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: tokenIn,
            tokenOut: weth,
            amountIn: amountIn
        )
        let trade2 = try await bestTradeSingleIn(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: weth,
            tokenOut: tokenOut,
            amountIn: trade1.tokenAmountOut.rawAmount
        )

        let path = SwapPath(trade1.swapPath.items + trade2.swapPath.items)
        let amountOut = try await quote(
            rpcSource: rpcSource,
            chain: chain,
            swapPath: path,
            tradeType: .exactIn,
            amount: amountIn
        )

        let slotPrices = [trade1.slotPrices.first, trade2.slotPrices.first].compactMap { $0 }
        return TradeV3(
            tradeType: .exactIn,
            swapPath: path,
            amountIn: amountIn,
            amountOut: amountOut,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            slotPrices: slotPrices
        )
    }

    private func bestTradeMultihopOut(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountOut: BigUInt
    ) async throws
        -> TradeV3 {
        let weth = try tokenFactory.etherToken(chain: chain)

        let trade1 = try await bestTradeSingleOut(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: weth,
            tokenOut: tokenOut,
            amountOut: amountOut
        )
        let trade2 = try await bestTradeSingleOut(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: tokenIn,
            tokenOut: weth,
            amountOut: trade1.tokenAmountIn.rawAmount
        )

        let path = SwapPath(trade1.swapPath.items + trade2.swapPath.items)
        let amountIn = try await quote(
            rpcSource: rpcSource,
            chain: chain,
            swapPath: path,
            tradeType: .exactOut,
            amount: amountOut
        )

        let slotPrices = [trade1.slotPrices.first, trade2.slotPrices.first].compactMap { $0 }
        return TradeV3(
            tradeType: .exactIn,
            swapPath: path,
            amountIn: amountIn,
            amountOut: amountOut,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            slotPrices: slotPrices
        )
    }

    private func call(rpcSource: RpcSource, chain: Chain, data: Data) async throws -> Data {
        do {
            let quoterAddress = dexType.quoterAddress(chain: chain)
            return try await EVMKit.Kit.call(
                networkManager: networkManager,
                rpcSource: rpcSource,
                contractAddress: quoterAddress,
                data: data
            )
        } catch {
            throw error
        }
    }
}

extension QuoterV2 {
    func bestTradeExactIn(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountIn: BigUInt
    ) async throws
        -> TradeV3 {
        try await bestTrade(
            rpcSource: rpcSource,
            chain: chain,
            tradeType: .exactIn,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amount: amountIn
        )
    }

    func bestTradeExactOut(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountOut: BigUInt
    ) async throws
        -> TradeV3 {
        try await bestTrade(
            rpcSource: rpcSource,
            chain: chain,
            tradeType: .exactOut,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amount: amountOut
        )
    }
}
