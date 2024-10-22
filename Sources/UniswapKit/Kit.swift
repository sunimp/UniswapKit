//
//  Kit.swift
//  UniswapKit
//
//  Created by Sun on 2020/6/24.
//

import Foundation

import BigInt
import EVMKit
import SWToolKit

// MARK: - Kit

public class Kit {
    // MARK: Properties

    private let tradeManager: TradeManager
    private let pairSelector: PairSelector
    private let tokenFactory: TokenFactory

    // MARK: Lifecycle

    init(tradeManager: TradeManager, pairSelector: PairSelector, tokenFactory: TokenFactory) {
        self.tradeManager = tradeManager
        self.pairSelector = pairSelector
        self.tokenFactory = tokenFactory
    }
}

extension Kit {
    public func routerAddress(chain: Chain) throws -> Address {
        try TradeManager.routerAddress(chain: chain)
    }

    public func etherToken(chain: Chain) throws -> Token {
        try tokenFactory.etherToken(chain: chain)
    }

    public func token(contractAddress: Address, decimals: Int) -> Token {
        tokenFactory.token(contractAddress: contractAddress, decimals: decimals)
    }

    public func swapData(rpcSource: RpcSource, chain: Chain, tokenIn: Token, tokenOut: Token) async throws -> SwapData {
        let tokenPairs = try pairSelector.tokenPairs(chain: chain, tokenA: tokenIn, tokenB: tokenOut)

        let pairs = try await withThrowingTaskGroup(of: Pair.self) { taskGroup in
            for (token, token2) in tokenPairs {
                taskGroup.addTask {
                    try await self.tradeManager.pair(rpcSource: rpcSource, chain: chain, tokenA: token, tokenB: token2)
                }
            }

            return try await taskGroup.reduce(into: [Pair]()) { result, pair in
                result.append(pair)
            }
        }

        return SwapData(pairs: pairs, tokenIn: tokenIn, tokenOut: tokenOut)
    }

    public func bestTradeExactIn(
        swapData: SwapData,
        amountIn: Decimal,
        options: TradeOptions = TradeOptions()
    ) throws
        -> TradeData {
        guard amountIn > 0 else {
            throw TradeError.zeroAmount
        }

        let tokenAmountIn = try TokenAmount(token: swapData.tokenIn, decimal: amountIn)

        let sortedTrades = try TradeManager.tradesExactIn(
            pairs: swapData.pairs,
            tokenAmountIn: tokenAmountIn,
            tokenOut: swapData.tokenOut
        ).sorted()

        guard let bestTrade = sortedTrades.first else {
            throw TradeError.tradeNotFound
        }

        return TradeData(trade: bestTrade, options: options)
    }

    public func bestTradeExactOut(
        swapData: SwapData,
        amountOut: Decimal,
        options: TradeOptions = TradeOptions()
    ) throws
        -> TradeData {
        guard amountOut > 0 else {
            throw TradeError.zeroAmount
        }

        let tokenAmountOut = try TokenAmount(token: swapData.tokenOut, decimal: amountOut)

        let sortedTrades = try TradeManager.tradesExactOut(
            pairs: swapData.pairs,
            tokenIn: swapData.tokenIn,
            tokenAmountOut: tokenAmountOut
        ).sorted()
        
        guard let bestTrade = sortedTrades.first else {
            throw TradeError.tradeNotFound
        }

        return TradeData(trade: bestTrade, options: options)
    }

    public func transactionData(receiveAddress: Address, chain: Chain, tradeData: TradeData) throws -> TransactionData {
        try tradeManager.transactionData(receiveAddress: receiveAddress, chain: chain, tradeData: tradeData)
    }
}

extension Kit {
    public static func instance() throws -> Kit {
        let networkManager = NetworkManager()
        let tradeManager = TradeManager(networkManager: networkManager)
        let tokenFactory = TokenFactory()
        let pairSelector = PairSelector(tokenFactory: tokenFactory)

        return Kit(tradeManager: tradeManager, pairSelector: pairSelector, tokenFactory: tokenFactory)
    }

    public static func addDecorators(to evmKit: EVMKit.Kit) {
        evmKit.add(methodDecorator: SwapMethodDecorator(contractMethodFactories: SwapContractMethodFactories.shared))
        evmKit.add(transactionDecorator: SwapTransactionDecorator())
    }
}

extension Kit {
    public enum FractionError: Error {
        case negativeDecimal
        case invalidSignificand(value: String)
    }

    public enum TradeError: Error {
        case zeroAmount
        case tradeNotFound
        case invalidTokensForSwap
    }

    public enum PairError: Error {
        case notInvolvedToken
        case insufficientReserves
        case insufficientReserveOut
    }

    public enum RouteError: Error {
        case emptyPairs
        case invalidPair(index: Int)
    }
}
