//
//  Token.swift
//
//  Created by Sun on 2020/7/9.
//

import Foundation

import EVMKit

// MARK: - Token

public enum Token {
    case eth(wethAddress: Address)
    case erc20(address: Address, decimals: Int)

    // MARK: Computed Properties

    public var address: Address {
        switch self {
        case let .eth(wethAddress): wethAddress
        case let .erc20(address, _): address
        }
    }

    public var isEther: Bool {
        switch self {
        case .eth: true
        default: false
        }
    }

    var decimals: Int {
        switch self {
        case .eth: 18
        case let .erc20(_, decimals): decimals
        }
    }

    // MARK: Functions

    func sortsBefore(token: Token) -> Bool {
        address.raw.ww.hexString.lowercased() < token.address.raw.ww.hexString.lowercased()
    }
}

// MARK: Equatable

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.eth(lhsWethAddress), .eth(rhsWethAddress)): lhsWethAddress == rhsWethAddress

        case let (.erc20(lhsAddress, lhsDecimals), .erc20(rhsAddress, rhsDecimals)): lhsAddress == rhsAddress &&
            lhsDecimals == rhsDecimals

        default: false
        }
    }
}

// MARK: CustomStringConvertible

extension Token: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eth: "[ETH]"
        case let .erc20(address, _): "[ERC20: \(address)]"
        }
    }
}
