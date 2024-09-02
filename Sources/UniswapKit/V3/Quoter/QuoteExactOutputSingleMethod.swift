//
//  QuoteExactOutputSingleMethod.swift
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class QuoteExactOutputSingleMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "quoteExactOutputSingle((address,address,uint256,uint24,uint160))"

    // MARK: Overridden Properties

    override var methodSignature: String { QuoteExactOutputSingleMethod.methodSignature }

    override var arguments: [Any] {
        [tokenIn, tokenOut, amountOut, fee, sqrtPriceLimitX96]
    }

    // MARK: Properties

    let tokenIn: Address
    let tokenOut: Address
    let fee: BigUInt
    let amountOut: BigUInt
    let sqrtPriceLimitX96: BigUInt

    // MARK: Lifecycle

    init(tokenIn: Address, tokenOut: Address, fee: KitV3.FeeAmount, amountOut: BigUInt, sqrtPriceLimitX96: BigUInt) {
        self.tokenIn = tokenIn
        self.tokenOut = tokenOut
        self.fee = fee.rawValue
        self.amountOut = amountOut
        self.sqrtPriceLimitX96 = sqrtPriceLimitX96

        super.init()
    }
}
