//
//  ExactInputMethod.swift
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import BigInt
import EVMKit

// MARK: - ExactInputMethod

class ExactInputMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "exactInput((bytes,address,uint256,uint256))"

    // MARK: Overridden Properties

    override var methodSignature: String { ExactInputMethod.methodSignature }

    override var arguments: [Any] {
        [ContractMethodHelper.DynamicStructParameter([path, recipient, amountIn, amountOutMinimum])]
    }

    // MARK: Properties

    let path: Data
    let recipient: Address
    let amountIn: BigUInt
    let amountOutMinimum: BigUInt

    // MARK: Lifecycle

    init(path: Data, recipient: Address, amountIn: BigUInt, amountOutMinimum: BigUInt) {
        self.path = path
        self.recipient = recipient
        self.amountIn = amountIn
        self.amountOutMinimum = amountOutMinimum

        super.init()
    }
}

extension ExactInputMethod {
    var tokenIn: Address {
        Address(raw: path.prefix(20))
    }

    var tokenOut: Address {
        Address(raw: path.suffix(20))
    }
}
