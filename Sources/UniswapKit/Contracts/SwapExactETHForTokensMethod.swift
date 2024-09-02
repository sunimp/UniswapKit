//
//  SwapExactETHForTokensMethod.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class SwapExactETHForTokensMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String {
        SwapExactETHForTokensMethod.methodSignature(supportingFeeOnTransfer: supportingFeeOnTransfer)
    }

    override var arguments: [Any] {
        [amountOutMin, path, to, deadline]
    }

    // MARK: Properties

    let amountOutMin: BigUInt
    let path: [Address]
    let to: Address
    let deadline: BigUInt

    private let supportingFeeOnTransfer: Bool

    // MARK: Lifecycle

    init(amountOut: BigUInt, path: [Address], to: Address, deadline: BigUInt, supportingFeeOnTransfer: Bool = false) {
        amountOutMin = amountOut
        self.path = path
        self.to = to
        self.deadline = deadline
        self.supportingFeeOnTransfer = supportingFeeOnTransfer

        super.init()
    }

    // MARK: Static Functions

    static func methodSignature(supportingFeeOnTransfer: Bool) -> String {
        let supporting = supportingFeeOnTransfer ? "SupportingFeeOnTransferTokens" : ""
        return "swapExactETHForTokens\(supporting)(uint256,address[],address,uint256)"
    }
}
