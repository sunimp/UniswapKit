//
//  Price.swift
//  UniswapKit
//
//  Created by Sun on 2020/7/15.
//

import Foundation

import BigInt

// MARK: - Price

struct Price {
    // MARK: Properties

    let fraction: Fraction

    private let baseToken: Token
    private let quoteToken: Token
    private let scalar: Fraction

    // MARK: Computed Properties

    var adjusted: Fraction {
        fraction * scalar
    }

    var decimalValue: Decimal? {
        adjusted.toDecimal(decimals: quoteToken.decimals)
    }

    var invertedPrice: Price {
        Price(baseToken: quoteToken, quoteToken: baseToken, fraction: fraction.inverted)
    }

    // MARK: Lifecycle

    init(baseToken: Token, quoteToken: Token, fraction: Fraction) {
        self.baseToken = baseToken
        self.quoteToken = quoteToken
        self.fraction = fraction

        scalar = Fraction(
            numerator: BigUInt(10).power(baseToken.decimals),
            denominator: BigUInt(10).power(quoteToken.decimals)
        )
    }

    init(baseTokenAmount: TokenAmount, quoteTokenAmount: TokenAmount) {
        self.init(
            baseToken: baseTokenAmount.token,
            quoteToken: quoteTokenAmount.token,
            fraction: Fraction(numerator: quoteTokenAmount.rawAmount, denominator: baseTokenAmount.rawAmount)
        )
    }
}

extension Price {
    public static func * (lhs: Price, rhs: Price) -> Price {
        let fraction = lhs.fraction * rhs.fraction
        return Price(baseToken: lhs.baseToken, quoteToken: rhs.quoteToken, fraction: fraction)
    }
}

// MARK: CustomStringConvertible

extension Price: CustomStringConvertible {
    public var description: String {
        "[baseToken: \(baseToken); quoteToken: \(quoteToken); value: \(decimalValue?.description ?? "nil")]"
    }
}
