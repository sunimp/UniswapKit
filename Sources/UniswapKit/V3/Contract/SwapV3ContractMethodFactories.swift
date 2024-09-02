//
//  SwapV3ContractMethodFactories.swift
//
//  Created by Sun on 2023/5/3.
//

import Foundation

import EVMKit

class SwapV3ContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = SwapV3ContractMethodFactories()

    // MARK: Lifecycle

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
