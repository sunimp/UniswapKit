//
//  UnwrapWeth9MethodFactory.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class UnwrapWeth9MethodFactory: IContractMethodFactory {
    let methodId: Data = ContractMethodHelper.methodId(signature: UnwrapWeth9Method.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            BigUInt.self,
            Address.self,
        ])
        guard let amountMinimum = parsedArguments[0] as? BigUInt,
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
