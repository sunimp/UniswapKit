//
//  SwapContractMethodFactories.swift
//  UniswapKit
//
//  Created by Sun on 2021/3/4.
//

import Foundation

import EVMKit

class SwapContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = SwapContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [
            SwapETHForExactTokensMethodFactory(),
            SwapExactETHForTokensMethodFactory(),
            SwapExactTokensForETHMethodFactory(),
            SwapExactTokensForTokensMethodFactory(),
            SwapTokensForExactETHMethodFactory(),
            SwapTokensForExactTokensMethodFactory(),
            SwapExactETHForTokensMethodSupportingFeeOnTransferFactory(),
            SwapExactTokensForETHMethodSupportingFeeOnTransferFactory(),
            SwapExactTokensForTokensMethodSupportingFeeOnTransferFactory(),
        ])
    }
}
