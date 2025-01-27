//
//  SwapExactTokensForETHMethod.swift
//  UniswapKit
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class SwapExactTokensForETHMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String {
        SwapExactTokensForETHMethod.methodSignature(supportingFeeOnTransfer: supportingFeeOnTransfer)
    }

    override var arguments: [Any] {
        [amountIn, amountOutMin, path, to, deadline]
    }

    // MARK: Properties

    let amountIn: BigUInt
    let amountOutMin: BigUInt
    let path: [Address]
    let to: Address
    let deadline: BigUInt

    private let supportingFeeOnTransfer: Bool

    // MARK: Lifecycle

    init(
        amountIn: BigUInt,
        amountOutMin: BigUInt,
        path: [Address],
        to: Address,
        deadline: BigUInt,
        supportingFeeOnTransfer: Bool = false
    ) {
        self.amountIn = amountIn
        self.amountOutMin = amountOutMin
        self.path = path
        self.to = to
        self.deadline = deadline
        self.supportingFeeOnTransfer = supportingFeeOnTransfer

        super.init()
    }

    // MARK: Static Functions

    static func methodSignature(supportingFeeOnTransfer: Bool) -> String {
        let supporting = supportingFeeOnTransfer ? "SupportingFeeOnTransferTokens" : ""
        return "swapExactTokensForETH\(supporting)(uint256,uint256,address[],address,uint256)"
    }
}
