//
//  Token.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

// MARK: - Token

public enum Token {
    case eth(wethAddress: Address)
    case erc20(address: Address, decimals: Int)

    public var address: Address {
        switch self {
        case .eth(let wethAddress): wethAddress
        case .erc20(let address, _): address
        }
    }

    var decimals: Int {
        switch self {
        case .eth: 18
        case .erc20(_, let decimals): decimals
        }
    }

    func sortsBefore(token: Token) -> Bool {
        address.raw.ww.hexString.lowercased() < token.address.raw.ww.hexString.lowercased()
    }

    public var isEther: Bool {
        switch self {
        case .eth: true
        default: false
        }
    }
}

// MARK: Equatable

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.eth(let lhsWethAddress), .eth(let rhsWethAddress)): lhsWethAddress == rhsWethAddress

        case (.erc20(let lhsAddress, let lhsDecimals), .erc20(let rhsAddress, let rhsDecimals)): lhsAddress == rhsAddress &&
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
        case .erc20(let address, _): "[ERC20: \(address)]"
        }
    }
}
