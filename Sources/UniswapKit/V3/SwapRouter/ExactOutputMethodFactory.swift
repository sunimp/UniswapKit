//
//  ExactOutputMethodFactory.swift
//
//  Created by Sun on 2023/5/3.
//

import Foundation

import BigInt
import EVMKit

class ExactOutputMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: ExactOutputMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            Data.self,
            Address.self,
            BigUInt.self,
            BigUInt.self,
            BigUInt.self,
        ])
        guard
            let path = parsedArguments[0] as? Data,
            let recipient = parsedArguments[1] as? Address,
            let amountOut = parsedArguments[2] as? BigUInt,
            let amountInMaximum = parsedArguments[3] as? BigUInt
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return ExactOutputMethod(
            path: path,
            recipient: recipient,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum
        )
    }
}
