//
//  MulticallMethod.swift
//  UniswapKit
//
//  Created by Sun on 2023/4/25.
//

import Foundation

import EVMKit

class MulticallMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "multicall(bytes[])"

    // MARK: Overridden Properties

    override var methodSignature: String { MulticallMethod.methodSignature }

    override var arguments: [Any] {
        [ContractMethodHelper.MulticallParameters(methods.map { $0.encodedABI() })]
    }

    // MARK: Properties

    let methods: [ContractMethod]

    // MARK: Lifecycle

    init(methods: [ContractMethod]) {
        self.methods = methods
        super.init()
    }
}
