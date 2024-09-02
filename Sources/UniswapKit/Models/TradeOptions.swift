//
//  TradeOptions.swift
//
//  Created by Sun on 2020/7/9.
//

import Foundation

import EVMKit

public struct TradeOptions {
    // MARK: Static Properties

    public static let defaultSlippage: Decimal = 0.5
    public static let defaultTtl: TimeInterval = 20 * 60

    // MARK: Properties

    public var allowedSlippage: Decimal
    public var ttl: TimeInterval
    public var recipient: Address?
    public var feeOnTransfer: Bool

    // MARK: Computed Properties

    var slippageFraction: Fraction {
        do {
            return try Fraction(decimal: allowedSlippage / 100)
        } catch {
            return Fraction(numerator: 5, denominator: 1000)
        }
    }

    // MARK: Lifecycle

    public init(
        allowedSlippage: Decimal = TradeOptions.defaultSlippage,
        ttl: TimeInterval = TradeOptions.defaultTtl,
        recipient: Address? = nil,
        feeOnTransfer: Bool = false
    ) {
        self.allowedSlippage = allowedSlippage
        self.ttl = ttl
        self.recipient = recipient
        self.feeOnTransfer = feeOnTransfer
    }
}
