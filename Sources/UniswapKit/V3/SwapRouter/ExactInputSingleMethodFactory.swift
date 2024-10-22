//
//  ExactInputSingleMethodFactory.swift
//  UniswapKit
//
//  Created by Sun on 2023/5/3.
//

import Foundation

import BigInt
import EVMKit

class ExactInputSingleMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: ExactInputSingleMethod.methodSignature)

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
        ])
        guard
            let tokenIn = parsedArguments[0] as? Address,
            let tokenOut = parsedArguments[1] as? Address,
            let fee = parsedArguments[2] as? BigUInt,
            let recipient = parsedArguments[3] as? Address,
            let amountIn = parsedArguments[4] as? BigUInt,
            let amountOutMinimum = parsedArguments[5] as? BigUInt,
            let sqrtPriceLimitX96 = parsedArguments[6] as? BigUInt
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return ExactInputSingleMethod(
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: fee,
            recipient: recipient,
            amountIn: amountIn,
            amountOutMinimum: amountOutMinimum,
            sqrtPriceLimitX96: sqrtPriceLimitX96
        )
    }
}
