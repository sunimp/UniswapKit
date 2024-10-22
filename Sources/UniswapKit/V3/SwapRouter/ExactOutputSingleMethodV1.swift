//
//  ExactOutputSingleMethodV1.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class ExactOutputSingleMethodV1: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "exactOutputSingle((address,address,uint24,address,uint256,uint256,uint256,uint160))"

    // MARK: Overridden Properties

    override var methodSignature: String { ExactOutputSingleMethodV1.methodSignature }

    override var arguments: [Any] {
        [tokenIn, tokenOut, fee, recipient, deadline, amountOut, amountInMaximum, sqrtPriceLimitX96]
    }

    // MARK: Properties

    let tokenIn: Address
    let tokenOut: Address
    let fee: BigUInt
    let recipient: Address
    let deadline: BigUInt
    let amountOut: BigUInt
    let amountInMaximum: BigUInt
    let sqrtPriceLimitX96: BigUInt

    // MARK: Lifecycle

    init(
        tokenIn: Address,
        tokenOut: Address,
        fee: BigUInt,
        recipient: Address,
        deadline: BigUInt,
        amountOut: BigUInt,
        amountInMaximum: BigUInt,
        sqrtPriceLimitX96: BigUInt
    ) {
        self.tokenIn = tokenIn
        self.tokenOut = tokenOut
        self.fee = fee
        self.recipient = recipient
        self.deadline = deadline
        self.amountOut = amountOut
        self.amountInMaximum = amountInMaximum
        self.sqrtPriceLimitX96 = sqrtPriceLimitX96

        super.init()
    }
}
