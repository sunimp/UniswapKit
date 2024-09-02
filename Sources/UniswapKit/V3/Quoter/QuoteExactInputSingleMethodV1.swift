//
//  QuoteExactInputSingleMethodV1.swift
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class QuoteExactInputSingleMethodV1: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "quoteExactInputSingle(address,address,uint24,uint256,uint160)"

    // MARK: Overridden Properties

    override var methodSignature: String { QuoteExactInputSingleMethodV1.methodSignature }

    override var arguments: [Any] {
        [tokenIn, tokenOut, fee, amountIn, sqrtPriceLimitX96]
    }

    // MARK: Properties

    let tokenIn: Address
    let tokenOut: Address
    let fee: BigUInt
    let amountIn: BigUInt
    let sqrtPriceLimitX96: BigUInt

    // MARK: Lifecycle

    init(tokenIn: Address, tokenOut: Address, fee: KitV3.FeeAmount, amountIn: BigUInt, sqrtPriceLimitX96: BigUInt) {
        self.tokenIn = tokenIn
        self.tokenOut = tokenOut
        self.fee = fee.rawValue
        self.amountIn = amountIn
        self.sqrtPriceLimitX96 = sqrtPriceLimitX96

        super.init()
    }
}
