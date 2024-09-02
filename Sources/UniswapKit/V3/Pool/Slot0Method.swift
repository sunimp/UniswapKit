//
//  Slot0Method.swift
//
//  Created by Sun on 2023/5/8.
//

import Foundation

import BigInt
import EVMKit

class Slot0Method: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "slot0()"

    // MARK: Overridden Properties

    override var methodSignature: String { Slot0Method.methodSignature }

    override var arguments: [Any] {
        []
    }
}
