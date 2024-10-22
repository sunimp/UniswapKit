//
//  SwapV3MethodDecorator.swift
//  UniswapKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import EVMKit

// MARK: - SwapV3MethodDecorator

class SwapV3MethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: SwapV3ContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: SwapV3ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension SwapV3MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
