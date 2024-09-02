//
//  GetPoolMethod.swift
//
//  Created by Sun on 2023/5/8.
//

import Foundation

import BigInt
import EVMKit

class GetPoolMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "getPool(address,address,uint24)"

    // MARK: Overridden Properties

    override var methodSignature: String { GetPoolMethod.methodSignature }

    override var arguments: [Any] {
        [token0, token1, fee]
    }

    // MARK: Properties

    let token0: Address
    let token1: Address
    let fee: BigUInt

    // MARK: Lifecycle

    init(token0: Address, token1: Address, fee: BigUInt) {
        self.token0 = token0
        self.token1 = token1
        self.fee = fee

        super.init()
    }
}
