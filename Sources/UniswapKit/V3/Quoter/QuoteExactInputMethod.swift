//
//  QuoteExactInputMethod.swift
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class QuoteExactInputMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "quoteExactInput(bytes,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { QuoteExactInputMethod.methodSignature }

    override var arguments: [Any] {
        [swapPath.abiEncodePacked, amountIn]
    }

    // MARK: Properties

    let swapPath: SwapPath
    let amountIn: BigUInt

    // MARK: Lifecycle

    init(swapPath: SwapPath, amountIn: BigUInt) {
        self.swapPath = swapPath
        self.amountIn = amountIn

        super.init()
    }
}
