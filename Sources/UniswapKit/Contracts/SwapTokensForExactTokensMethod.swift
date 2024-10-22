//
//  SwapTokensForExactTokensMethod.swift
//  UniswapKit
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class SwapTokensForExactTokensMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "swapTokensForExactTokens(uint256,uint256,address[],address,uint256)"

    // MARK: Overridden Properties

    override var methodSignature: String { SwapTokensForExactTokensMethod.methodSignature }

    override var arguments: [Any] {
        [amountOut, amountInMax, path, to, deadline]
    }

    // MARK: Properties

    let amountOut: BigUInt
    let amountInMax: BigUInt
    let path: [Address]
    let to: Address
    let deadline: BigUInt

    // MARK: Lifecycle

    init(amountOut: BigUInt, amountInMax: BigUInt, path: [Address], to: Address, deadline: BigUInt) {
        self.amountOut = amountOut
        self.amountInMax = amountInMax
        self.path = path
        self.to = to
        self.deadline = deadline

        super.init()
    }
}
