//
//  SwapExactETHForTokensMethodFactory.swift
//  UniswapKit
//
//  Created by Sun on 2021/3/4.
//

import Foundation

import BigInt
import EVMKit

class SwapExactETHForTokensMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper
        .methodID(signature: SwapExactETHForTokensMethod.methodSignature(supportingFeeOnTransfer: false))

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(
            inputArguments: inputArguments,
            argumentTypes: [BigUInt.self, [Address].self, Address.self, BigUInt.self]
        )
        guard
            let amountOut = parsedArguments[0] as? BigUInt,
            let path = parsedArguments[1] as? [Address],
            let to = parsedArguments[2] as? Address,
            let deadline = parsedArguments[3] as? BigUInt
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return SwapExactETHForTokensMethod(
            amountOut: amountOut,
            path: path,
            to: to,
            deadline: deadline,
            supportingFeeOnTransfer: false
        )
    }
}
