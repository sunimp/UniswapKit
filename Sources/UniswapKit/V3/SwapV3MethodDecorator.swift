//
//  SwapV3MethodDecorator.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

// MARK: - SwapV3MethodDecorator

class SwapV3MethodDecorator {
    private let contractMethodFactories: SwapV3ContractMethodFactories

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
