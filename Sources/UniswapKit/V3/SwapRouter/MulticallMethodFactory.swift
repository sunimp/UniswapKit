//
//  MulticallMethodFactory.swift
//
//  Created by Sun on 2023/5/17.
//

import Foundation

import BigInt
import EVMKit

// MARK: - MulticallMethodFactory

class MulticallMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: MulticallMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let factories = SwapV3ContractMethodFactories()

        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            ContractMethodHelper.MulticallParameters.self,
        ])

        guard !parsedArguments.isEmpty, let methodArray = parsedArguments[0] as? [Data] else {
            throw ParseError.cantParseMethods
        }

        let methods: [ContractMethod] = methodArray.compactMap { argument -> ContractMethod? in
            guard let data = argument.ww.hex.ww.hexData else {
                return nil
            }
            return factories.createMethod(input: data)
        }

        guard !methods.isEmpty else {
            throw ParseError.cantParseMethods
        }

        return MulticallMethod(methods: methods)
    }
}

// MARK: MulticallMethodFactory.ParseError

extension MulticallMethodFactory {
    enum ParseError: Error {
        case cantParseMethods
    }
}
