//
//  TransactionRecord.swift
//  UniswapKit-Example
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EVMKit

struct TransactionRecord {
    let transactionHash: String
    let transactionHashData: Data
    let timestamp: Int
    let isFailed: Bool

    let from: Address?
    let to: Address?
    let amount: Decimal?
    let input: String?

    let blockHeight: Int?
    let transactionIndex: Int?

    let decoration: String
}
