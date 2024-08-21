//
//  SwapMethodDecorator.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class SwapMethodDecorator {
    private let contractMethodFactories: SwapContractMethodFactories

    init(contractMethodFactories: SwapContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

extension SwapMethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
