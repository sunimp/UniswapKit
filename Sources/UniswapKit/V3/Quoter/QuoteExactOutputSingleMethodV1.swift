//
//  QuoteExactOutputSingleMethodV1.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class QuoteExactOutputSingleMethodV1: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "quoteExactOutputSingle(address,address,uint24,uint256,uint160)"

    // MARK: Overridden Properties

    override var methodSignature: String { QuoteExactOutputSingleMethodV1.methodSignature }

    override var arguments: [Any] {
        [tokenIn, tokenOut, fee, amountOut, sqrtPriceLimitX96]
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
