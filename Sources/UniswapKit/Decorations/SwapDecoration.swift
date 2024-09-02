//
//  SwapDecoration.swift
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt
import EIP20Kit
import EVMKit

// MARK: - SwapDecoration

public class SwapDecoration: TransactionDecoration {
    // MARK: Properties

    public let contractAddress: Address
    public let amountIn: Amount
    public let amountOut: Amount
    public let tokenIn: Token
    public let tokenOut: Token
    public let recipient: Address?
    public let deadline: BigUInt?

    // MARK: Lifecycle

    public init(
        contractAddress: Address,
        amountIn: Amount,
        amountOut: Amount,
        tokenIn: Token,
        tokenOut: Token,
        recipient: Address?,
        deadline: BigUInt?
    ) {
        self.contractAddress = contractAddress
        self.amountIn = amountIn
        self.amountOut = amountOut
        self.tokenIn = tokenIn
        self.tokenOut = tokenOut
        self.recipient = recipient
        self.deadline = deadline

        super.init()
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        var tags = [
            tag(token: tokenIn, type: .swap),
            tag(token: tokenOut, type: .swap),
            tag(token: tokenIn, type: .outgoing),
        ]

        if recipient == nil {
            tags.append(tag(token: tokenOut, type: .incoming))
        }

        return tags
    }

    // MARK: Functions

    private func tag(token: Token, type: TransactionTag.TagType) -> TransactionTag {
        let addresses = recipient.map { [$0.hex] } ?? []

        switch token {
        case .evmCoin: return TransactionTag(type: type, protocol: .native, addresses: addresses)
        case let .eip20Coin(tokenAddress, _): return TransactionTag(
                type: type,
                protocol: .eip20,
                contractAddress: tokenAddress,
                addresses: addresses
            )
        }
    }
}

extension SwapDecoration {
    public enum Amount {
        case exact(value: BigUInt)
        case extremum(value: BigUInt)
    }

    public enum Token {
        case evmCoin
        case eip20Coin(address: Address, tokenInfo: TokenInfo?)

        // MARK: Computed Properties

        public var tokenInfo: TokenInfo? {
            switch self {
            case let .eip20Coin(_, tokenInfo): tokenInfo
            default: nil
            }
        }
    }
}
