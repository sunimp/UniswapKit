//
//  QuoteExactOutputMethod.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class QuoteExactOutputMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "quoteExactOutput(bytes,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { QuoteExactOutputMethod.methodSignature }

    override var arguments: [Any] {
        [swapPath.abiEncodePacked, amountOut]
    }

    // MARK: Properties

    let swapPath: SwapPath
    let amountOut: BigUInt

    // MARK: Lifecycle

    init(swapPath: SwapPath, amountOut: BigUInt) {
        self.swapPath = swapPath
        self.amountOut = amountOut

        super.init()
    }
}
