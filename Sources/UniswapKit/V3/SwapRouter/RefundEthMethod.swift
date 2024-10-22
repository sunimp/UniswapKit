//
//  RefundEthMethod.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import EVMKit

class RefundEthMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "refundETH()"

    // MARK: Overridden Properties

    override var methodSignature: String { RefundEthMethod.methodSignature }

    override var arguments: [Any] {
        []
    }
}
