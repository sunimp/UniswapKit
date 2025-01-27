//
//  Fraction.swift
//  UniswapKit
//
//  Created by Sun on 2020/7/15.
//

import Foundation

import BigInt

// MARK: - Fraction

struct Fraction {
    // MARK: Properties

    let numerator: BigUInt
    let denominator: BigUInt

    // MARK: Computed Properties

    var quotient: BigUInt {
        numerator / denominator
    }

    var inverted: Fraction {
        Fraction(numerator: denominator, denominator: numerator)
    }

    // MARK: Lifecycle

    init(numerator: BigUInt, denominator: BigUInt = 1) {
        self.numerator = numerator
        self.denominator = numerator == 0 ? 1 : denominator
    }

    init(decimal: Decimal) throws {
        guard decimal.sign == .plus else {
            throw Kit.FractionError.negativeDecimal
        }

        guard let numerator = BigUInt(decimal.significand.description) else {
            throw Kit.FractionError.invalidSignificand(value: decimal.significand.description)
        }

        if decimal.exponent > 0 {
            self.numerator = numerator * BigUInt(10).power(decimal.exponent)
            denominator = 1
        } else {
            self.numerator = numerator
            denominator = BigUInt(10).power(-decimal.exponent)
        }
    }

    // MARK: Functions

    func toDecimal(decimals: Int) -> Decimal? {
        let adjustedNumerator = numerator * BigUInt(10).power(decimals)
        let value = adjustedNumerator / denominator

        guard let significand = Decimal(string: value.description) else {
            return nil
        }

        return Decimal(sign: .plus, exponent: -decimals, significand: significand)
    }
}

extension Fraction {
    public static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        if lhs.denominator == rhs.denominator {
            return Fraction(numerator: lhs.numerator + rhs.numerator, denominator: lhs.denominator)
        }

        return Fraction(
            numerator: lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator,
            denominator: lhs.denominator * rhs.denominator
        )
    }

    public static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
        if lhs.denominator == rhs.denominator {
            return Fraction(numerator: lhs.numerator - rhs.numerator, denominator: lhs.denominator)
        }

        return Fraction(
            numerator: lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator,
            denominator: lhs.denominator * rhs.denominator
        )
    }

    public static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
        Fraction(
            numerator: lhs.numerator * rhs.numerator,
            denominator: lhs.denominator * rhs.denominator
        )
    }

    public static func * (lhs: Fraction, rhs: BigInt) -> Fraction {
        let uint = BigUInt(abs(rhs))
        let positive = rhs >= 0

        return Fraction(
            numerator: lhs.numerator * (positive ? uint : 1),
            denominator: lhs.denominator * (positive ? 1 : uint)
        )
    }

    public static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
        Fraction(
            numerator: lhs.numerator * rhs.denominator,
            denominator: lhs.denominator * rhs.numerator
        )
    }
}

// MARK: Comparable

extension Fraction: Comparable {
    public static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
    }

    public static func == (lhs: Fraction, rhs: Fraction) -> Bool {
        lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator
    }
}

// MARK: CustomStringConvertible

extension Fraction: CustomStringConvertible {
    public var description: String {
        "\(numerator) / \(denominator)"
    }
}
