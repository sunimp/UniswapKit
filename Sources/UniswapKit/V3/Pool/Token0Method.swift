//
//  Token0Method.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Token0Method: ContractMethod {
    static let methodSignature = "token0()"

    override var methodSignature: String { Token0Method.methodSignature }

    override var arguments: [Any] {
        []
    }
}
