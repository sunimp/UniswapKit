//
//  SwapV3ContractMethodFactories.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class SwapV3ContractMethodFactories: ContractMethodFactories {
    static let shared = SwapV3ContractMethodFactories()

    override init() {
        super.init()
        register(factories: [
            ExactInputSingleMethodFactory(),
            ExactOutputSingleMethodFactory(),
            ExactInputSingleMethodV1Factory(),
            ExactOutputSingleMethodV1Factory(),
            ExactInputMethodFactory(),
            ExactOutputMethodFactory(),
            UnwrapWeth9MethodFactory(),
            MulticallMethodFactory(),
        ])
    }
}
