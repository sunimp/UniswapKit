//
//  SwapContractMethodFactories.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class SwapContractMethodFactories: ContractMethodFactories {
    static let shared = SwapContractMethodFactories()

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
