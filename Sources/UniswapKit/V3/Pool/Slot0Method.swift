//
//  Slot0Method.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Slot0Method: ContractMethod {
    static let methodSignature = "slot0()"

    override var methodSignature: String { Slot0Method.methodSignature }

    override var arguments: [Any] {
        []
    }
}
