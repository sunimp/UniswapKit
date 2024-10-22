//
//  UnwrapWeth9Method.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

class UnwrapWeth9Method: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "unwrapWETH9(uint256,address)"

    // MARK: Overridden Properties

    override var methodSignature: String { UnwrapWeth9Method.methodSignature }

    override var arguments: [Any] {
        [amountMinimum, recipient]
    }

    // MARK: Properties

    let amountMinimum: BigUInt
    let recipient: Address

    // MARK: Lifecycle

    init(amountMinimum: BigUInt, recipient: Address) {
        self.amountMinimum = amountMinimum
        self.recipient = recipient

        super.init()
    }
}
