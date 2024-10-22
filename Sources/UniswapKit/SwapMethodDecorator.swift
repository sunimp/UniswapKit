//
//  SwapMethodDecorator.swift
//  UniswapKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import EVMKit

// MARK: - SwapMethodDecorator

class SwapMethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: SwapContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: SwapContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension SwapMethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
