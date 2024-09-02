//
//  TradeDataV3.swift
//
//  Created by Sun on 2020/7/10.
//

import Foundation

import BigInt

// MARK: - TradeDataV3

public class TradeDataV3 {
    // MARK: Properties

    public let options: TradeOptions

    let trade: TradeV3

    // MARK: Computed Properties

    var tokenAmountInMax: TokenAmount {
        let amountInMax =
            ((Fraction(numerator: 1) + options.slippageFraction) * Fraction(numerator: trade.tokenAmountIn.rawAmount))
                .quotient
        return TokenAmount(token: trade.tokenAmountIn.token, rawAmount: amountInMax)
    }

    var tokenAmountOutMin: TokenAmount {
        let amountOutMin = (
            (Fraction(numerator: 1) + options.slippageFraction)
                .inverted * Fraction(numerator: trade.tokenAmountOut.rawAmount)
        ).quotient
        return TokenAmount(token: trade.tokenAmountOut.token, rawAmount: amountOutMin)
    }

    // MARK: Lifecycle

    public init(trade: TradeV3, options: TradeOptions) {
        self.trade = trade
        self.options = options
    }
}

extension TradeDataV3 {
    var isSingleSwap: Bool { trade.swapPath.isSingle }
    var singleSwapFee: KitV3.FeeAmount { trade.swapPath.firstFeeAmount }
}

extension TradeDataV3 {
    public var type: TradeType {
        trade.type
    }

    public var amountIn: Decimal? {
        trade.tokenAmountIn.decimalAmount
    }

    public var amountOut: Decimal? {
        trade.tokenAmountOut.decimalAmount
    }

    public var amountInMax: Decimal? {
        tokenAmountInMax.decimalAmount
    }

    public var amountOutMin: Decimal? {
        tokenAmountOutMin.decimalAmount
    }

    public var executionPrice: Decimal? {
        trade.executionPrice.decimalValue
    }

    public var executionPriceInverted: Decimal? {
        trade.executionPrice.invertedPrice.decimalValue
    }

    public var priceImpact: Decimal? {
        trade.priceImpact
    }
}
