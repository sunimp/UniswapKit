//
//  GetReservesMethod.swift
//
//  Created by Sun on 2020/9/22.
//

import Foundation

import BigInt
import EVMKit

class GetReservesMethod: ContractMethod {
    override var methodSignature: String { "getReserves()" }
    override var arguments: [Any] { [] }
}
