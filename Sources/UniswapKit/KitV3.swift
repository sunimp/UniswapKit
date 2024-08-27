//
//  KitV3.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit
import WWToolKit

// MARK: - KitV3

public class KitV3 {
    private let dexType: DexType
    private let quoter: QuoterV2
    private let swapRouter: SwapRouter
    private let tokenFactory: TokenFactory

    init(dexType: DexType, quoter: QuoterV2, swapRouter: SwapRouter, tokenFactory: TokenFactory) {
        self.dexType = dexType
        self.quoter = quoter
        self.swapRouter = swapRouter
        self.tokenFactory = tokenFactory
    }
}

extension KitV3 {
    public func routerAddress(chain: Chain) -> Address {
        dexType.routerAddress(chain: chain)
    }

    public func etherToken(chain: Chain) throws -> Token {
        try tokenFactory.etherToken(chain: chain)
    }

    public func token(contractAddress: Address, decimals: Int) -> Token {
        tokenFactory.token(contractAddress: contractAddress, decimals: decimals)
    }

    public func bestTradeExactIn(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountIn: Decimal,
        options: TradeOptions
    ) async throws -> TradeDataV3 {
        guard let amountIn = BigUInt(amountIn.ww.roundedString(decimal: tokenIn.decimals)), !amountIn.isZero else {
            throw TradeError.zeroAmount
        }

        let trade = try await quoter.bestTradeExactIn(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amountIn: amountIn
        )
        return TradeDataV3(trade: trade, options: options)
    }

    public func bestTradeExactOut(
        rpcSource: RpcSource,
        chain: Chain,
        tokenIn: Token,
        tokenOut: Token,
        amountOut: Decimal,
        options: TradeOptions
    ) async throws -> TradeDataV3 {
        guard let amountOut = BigUInt(amountOut.ww.roundedString(decimal: tokenOut.decimals)), !amountOut.isZero else {
            throw TradeError.zeroAmount
        }

        let trade = try await quoter.bestTradeExactOut(
            rpcSource: rpcSource,
            chain: chain,
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            amountOut: amountOut
        )
        return TradeDataV3(trade: trade, options: options)
    }

    public func transactionData(
        receiveAddress: Address,
        chain: Chain,
        bestTrade: TradeDataV3,
        tradeOptions: TradeOptions
    ) throws -> TransactionData {
        swapRouter.transactionData(receiveAddress: receiveAddress, chain: chain, tradeData: bestTrade, tradeOptions: tradeOptions)
    }
}

extension KitV3 {
    
    public static func instance(dexType: DexType) throws -> KitV3 {
        let networkManager = NetworkManager()
        let tokenFactory = TokenFactory()
        let quoter = QuoterV2(networkManager: networkManager, tokenFactory: tokenFactory, dexType: dexType)
        let swapRouter = SwapRouter(dexType: dexType)
        let uniswapKit = KitV3(dexType: dexType, quoter: quoter, swapRouter: swapRouter, tokenFactory: tokenFactory)

        return uniswapKit
    }

    public static func addDecorators(to evmKit: EvmKit.Kit) throws {
        let tokenFactory = TokenFactory()
        evmKit.add(methodDecorator: SwapV3MethodDecorator(contractMethodFactories: SwapV3ContractMethodFactories.shared))
        try evmKit
            .add(transactionDecorator: SwapV3TransactionDecorator(
                wethAddress: tokenFactory.etherToken(chain: evmKit.chain)
                    .address
            ))
    }

    public static func isSupported(chain: Chain) -> Bool {
        switch chain {
        case .ethereumGoerli, .ethereum, .polygon, .optimism, .arbitrumOne, .binanceSmartChain: true
        default: false
        }
    }
}

extension KitV3 {
    
    public enum FeeAmount: BigUInt, CaseIterable {
        case lowest = 100
        case low = 500
        case mediumPancakeSwap = 2500
        case mediumUniswap = 3000
        case high = 10000

        public static func sorted(dexType: DexType) -> [FeeAmount] {
            [
                .lowest,
                .low,
                dexType.mediumFeeAmount,
                .high,
            ]
        }
    }

    public enum TradeError: Error {
        case zeroAmount
        case tradeNotFound
        case invalidTokensForSwap
    }
}

// MARK: KitV3.KitError

extension KitV3 {
    enum KitError: Error {
        case unsupportedChain
    }
}
