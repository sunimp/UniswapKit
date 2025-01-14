//
//  TradeV3.swift
//  UniswapKit
//
//  Created by Sun on 2023/5/3.
//

import Foundation

import BigInt

// MARK: - TradeV3

public class TradeV3 {
    // MARK: Properties

    public let type: TradeType

    let swapPath: SwapPath
    let executionPrice: Price
    let slotPrices: [Decimal]
    let tokenAmountIn: TokenAmount
    let tokenAmountOut: TokenAmount

    // MARK: Lifecycle

    public init(
        tradeType: TradeType,
        swapPath: SwapPath,
        amountIn: BigUInt,
        amountOut: BigUInt,
        tokenIn: Token,
        tokenOut: Token,
        slotPrices: [Decimal]
    ) {
        type = tradeType
        self.swapPath = swapPath
        self.slotPrices = slotPrices

        tokenAmountIn = TokenAmount(token: tokenIn, rawAmount: amountIn)
        tokenAmountOut = TokenAmount(token: tokenOut, rawAmount: amountOut)

        executionPrice = Price(baseTokenAmount: tokenAmountIn, quoteTokenAmount: tokenAmountOut)
    }
}

extension TradeV3 {
    public var priceImpact: Decimal? {
        let decimals = tokenAmountIn.token.decimals - tokenAmountOut.token.decimals
        let tradePrice = PriceImpactHelper.price(
            in: tokenAmountIn.rawAmount,
            out: tokenAmountOut.rawAmount,
            shift: decimals
        )

        var slotPrice: Decimal?
        if !slotPrices.isEmpty {
            var result: Decimal = 1
            for decimal in slotPrices {
                result *= decimal
            }
            slotPrice = result
        } else {
            slotPrice = nil
        }

        guard
            let slotPrice,
            let tradePrice
        else {
            return nil
        }

        return PriceImpactHelper.impact(price: slotPrice, real: tradePrice)
    }
}
