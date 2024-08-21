//
//  GetReservesMethod.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class GetReservesMethod: ContractMethod {
    override var methodSignature: String { "getReserves()" }
    override var arguments: [Any] { [] }
}
