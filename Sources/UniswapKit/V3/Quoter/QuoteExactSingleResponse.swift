//
//  QuoteExactSingleResponse.swift
//  UniswapKit
//
//  Created by Sun on 2023/5/8.
//

import Foundation

import BigInt

class QuoteExactSingleResponse {
    // MARK: Properties

    let amount: BigUInt
    let sqrtPriceX96After: BigUInt
    let initializedTicksCrossed: BigUInt
    let gasEstimate: BigUInt

    // MARK: Lifecycle

    init?(data: Data) {
        guard data.count == 128 else {
            return nil
        }

        amount = BigUInt(data[0 ..< 32])
        sqrtPriceX96After = BigUInt(data[32 ..< 64])
        initializedTicksCrossed = BigUInt(data[64 ..< 96])
        gasEstimate = BigUInt(data[96 ..< 128])
    }
}
