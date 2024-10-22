//
//  TokenAmount.swift
//  UniswapKit
//
//  Created by Sun on 2020/7/9.
//

import Foundation

import BigInt

// MARK: - TokenAmount

struct TokenAmount {
    // MARK: Properties

    let token: Token
    let fraction: Fraction

    // MARK: Computed Properties

    var rawAmount: BigUInt {
        fraction.numerator
    }

    var decimalAmount: Decimal? {
        fraction.toDecimal(decimals: token.decimals)
    }

    // MARK: Lifecycle

    init(token: Token, rawAmount: BigUInt) {
        self.token = token
        fraction = Fraction(numerator: rawAmount, denominator: BigUInt(10).power(token.decimals))
    }

    init(token: Token, decimal: Decimal) throws {
        guard decimal.sign == .plus else {
            throw Kit.FractionError.negativeDecimal
        }

        guard let significand = BigUInt(decimal.significand.description) else {
            throw Kit.FractionError.invalidSignificand(value: decimal.significand.description)
        }

        let rawAmount: BigUInt =
            if decimal.exponent < -token.decimals {
                significand / BigUInt(10).power(-decimal.exponent - token.decimals)
            } else {
                significand * BigUInt(10).power(token.decimals + decimal.exponent)
            }

        self.init(token: token, rawAmount: rawAmount)
    }
}

// MARK: Comparable

extension TokenAmount: Comparable {
    public static func < (lhs: TokenAmount, rhs: TokenAmount) -> Bool {
        lhs.fraction < rhs.fraction
    }

    public static func == (lhs: TokenAmount, rhs: TokenAmount) -> Bool {
        lhs.fraction == rhs.fraction
    }
}

// MARK: CustomStringConvertible

extension TokenAmount: CustomStringConvertible {
    public var description: String {
        let amountString = decimalAmount?.description ?? "nil"
        return "[token: \(token); amount: \(amountString)]"
    }
}
