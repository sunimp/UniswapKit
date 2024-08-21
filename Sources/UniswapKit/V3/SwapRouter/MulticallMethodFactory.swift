//
//  MulticallMethodFactory.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class MulticallMethodFactory: IContractMethodFactory {
    let methodId: Data = ContractMethodHelper.methodId(signature: MulticallMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let factories = SwapV3ContractMethodFactories()

        let parsedArguments = ContractMethodHelper.decodeABI(inputArguments: inputArguments, argumentTypes: [
            ContractMethodHelper.MulticallParameters.self,
        ])

        guard parsedArguments.count > 0, let methodArray = parsedArguments[0] as? [Data] else {
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

extension MulticallMethodFactory {
    enum ParseError: Error {
        case cantParseMethods
    }
}
