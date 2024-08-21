//
//  SwapData.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct SwapData {
    let pairs: [Pair]
    let tokenIn: Token
    let tokenOut: Token
}

extension SwapData: CustomStringConvertible {
    public var description: String {
        let pairsInfo = pairs.map { "\($0)" }.joined(separator: "\n")
        return "[tokenIn: \(tokenIn); tokenOut: \(tokenOut)]\n\(pairsInfo)"
    }
}
