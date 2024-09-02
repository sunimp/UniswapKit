//
//  SwapETHForExactTokensMethodFactory.swift
//
//  Created by Sun on 2021/3/4.
//

import Foundation

import BigInt
import EVMKit

class SwapETHForExactTokensMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: SwapETHForExactTokensMethod.methodSignature)

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

        return SwapETHForExactTokensMethod(amountOut: amountOut, path: path, to: to, deadline: deadline)
    }
}
