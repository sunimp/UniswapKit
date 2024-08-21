//
//  RefundEthMethod.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class RefundEthMethod: ContractMethod {
    static let methodSignature = "refundETH()"

    override var methodSignature: String { RefundEthMethod.methodSignature }

    override var arguments: [Any] {
        []
    }
}
