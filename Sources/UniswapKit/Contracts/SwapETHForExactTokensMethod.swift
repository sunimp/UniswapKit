//
//  SwapETHForExactTokensMethod.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class SwapETHForExactTokensMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "swapETHForExactTokens(uint256,address[],address,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { SwapETHForExactTokensMethod.methodSignature }

    override var arguments: [Any] {
        [amountOut, path, to, deadline]
    }

    // MARK: Properties

    let amountOut: BigUInt
    let path: [Address]
    let to: Address
    let deadline: BigUInt

    // MARK: Lifecycle

    init(amountOut: BigUInt, path: [Address], to: Address, deadline: BigUInt) {
        self.amountOut = amountOut
        self.path = path
        self.to = to
        self.deadline = deadline

        super.init()
    }
}
