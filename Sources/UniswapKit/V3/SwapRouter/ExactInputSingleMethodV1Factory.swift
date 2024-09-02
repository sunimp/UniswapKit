//
//  ExactInputSingleMethodV1Factory.swift
//
//  Created by Sun on 2023/5/3.
//

import Foundation

import BigInt
import EVMKit

class ExactInputSingleMethodV1Factory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: ExactInputSingleMethodV1.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            Address.self,
            Address.self,
            BigUInt.self,
            Address.self,
            BigUInt.self,
            BigUInt.self,
            BigUInt.self,
            BigUInt.self,
        ])
        guard
            let tokenIn = parsedArguments[0] as? Address,
            let tokenOut = parsedArguments[1] as? Address,
            let fee = parsedArguments[2] as? BigUInt,
            let recipient = parsedArguments[3] as? Address,
            let deadline = parsedArguments[4] as? BigUInt,
            let amountIn = parsedArguments[5] as? BigUInt,
            let amountOutMinimum = parsedArguments[6] as? BigUInt,
            let sqrtPriceLimitX96 = parsedArguments[7] as? BigUInt
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return ExactInputSingleMethodV1(
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: fee,
            recipient: recipient,
            deadline: deadline,
            amountIn: amountIn,
            amountOutMinimum: amountOutMinimum,
            sqrtPriceLimitX96: sqrtPriceLimitX96
        )
    }
}
