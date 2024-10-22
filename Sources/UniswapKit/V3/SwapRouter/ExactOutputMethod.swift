//
//  ExactOutputMethod.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

// MARK: - ExactOutputMethod

class ExactOutputMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "exactOutput((bytes,address,uint256,uint256))"

    // MARK: Overridden Properties

    override var methodSignature: String { ExactOutputMethod.methodSignature }

    override var arguments: [Any] {
        [ContractMethodHelper.DynamicStructParameter([path, recipient, amountOut, amountInMaximum])]
    }

    // MARK: Properties

    let path: Data
    let recipient: Address
    let amountOut: BigUInt
    let amountInMaximum: BigUInt

    // MARK: Lifecycle

    init(path: Data, recipient: Address, amountOut: BigUInt, amountInMaximum: BigUInt) {
        self.path = path
        self.recipient = recipient
        self.amountOut = amountOut
        self.amountInMaximum = amountInMaximum

        super.init()
    }
}

extension ExactOutputMethod {
    var tokenIn: Address {
        Address(raw: path.suffix(20))
    }

    var tokenOut: Address {
        Address(raw: path.prefix(20))
    }
}
