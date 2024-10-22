//
//  SwapExactTokensForETHMethodSupportingFeeOnTransferFactory.swift
//  UniswapKit
//
//  Created by Sun on 2021/3/4.
//

import Foundation

import BigInt
import EVMKit

class SwapExactTokensForETHMethodSupportingFeeOnTransferFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper
        .methodID(signature: SwapExactTokensForETHMethod.methodSignature(supportingFeeOnTransfer: true))

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(
            inputArguments: inputArguments,
            argumentTypes: [BigUInt.self, BigUInt.self, [Address].self, Address.self, BigUInt.self]
        )
        guard
            let amountIn = parsedArguments[0] as? BigUInt,
            let amountOutMin = parsedArguments[1] as? BigUInt,
            let path = parsedArguments[2] as? [Address],
            let to = parsedArguments[3] as? Address,
            let deadline = parsedArguments[4] as? BigUInt
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return SwapExactTokensForETHMethod(
            amountIn: amountIn,
            amountOutMin: amountOutMin,
            path: path,
            to: to,
            deadline: deadline,
            supportingFeeOnTransfer: true
        )
    }
}
