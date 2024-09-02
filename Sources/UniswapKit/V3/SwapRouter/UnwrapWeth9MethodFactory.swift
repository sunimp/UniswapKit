//
//  UnwrapWeth9MethodFactory.swift
//
//  Created by Sun on 2023/5/17.
//

import Foundation

import BigInt
import EVMKit

class UnwrapWeth9MethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: UnwrapWeth9Method.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            BigUInt.self,
            Address.self,
        ])
        guard
            let amountMinimum = parsedArguments[0] as? BigUInt,
            let recipient = parsedArguments[1] as? Address
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return UnwrapWeth9Method(
            amountMinimum: amountMinimum,
            recipient: recipient
        )
    }
}
