//
//  SwapData.swift
//  UniswapKit
//
//  Created by Sun on 2020/7/9.
//

import Foundation

// MARK: - SwapData

public struct SwapData {
    let pairs: [Pair]
    let tokenIn: Token
    let tokenOut: Token
}

// MARK: CustomStringConvertible

extension SwapData: CustomStringConvertible {
    public var description: String {
        let pairsInfo = pairs.map { "\($0)" }.joined(separator: "\n")
        return "[tokenIn: \(tokenIn); tokenOut: \(tokenOut)]\n\(pairsInfo)"
    }
}
