//
//  Token0Method.swift
//
//  Created by Sun on 2023/5/8.
//

import Foundation

import BigInt
import EVMKit

class Token0Method: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "token0()"

    // MARK: Overridden Properties

    override var methodSignature: String { Token0Method.methodSignature }

    override var arguments: [Any] {
        []
    }
}
