//
//  SwapPath.swift
//  UniswapKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

// MARK: - SwapPath

public class SwapPath {
    public let items: [SwapPathItem]

    public init(_ items: [SwapPathItem]) {
        self.items = items
    }

    private func encodeUnit24(value: BigUInt) -> Data {
        let data = value.serialize()
        let prePadding = Data(repeating: 0, count: max(0, 3 - data.count))
        return prePadding + data
    }
}

extension SwapPath {
    var isSingle: Bool { items.count == 1 }
    var firstFeeAmount: KitV3.FeeAmount { items.first!.fee }

    var abiEncodePacked: Data {
        var result = Data()
        guard let token1 = items.first?.token1 else {
            return result
        }

        result += token1.raw

        for item in items {
            result += encodeUnit24(value: item.fee.rawValue) + item.token2.raw
        }

        return result
    }
}

// MARK: SwapPath.PathError

extension SwapPath {
    enum PathError: Error {
        case empty
    }
}

// MARK: - SwapPathItem

public struct SwapPathItem {
    let token1: Address
    let token2: Address
    let fee: KitV3.FeeAmount

    public init(token1: Address, token2: Address, fee: KitV3.FeeAmount) {
        self.token1 = token1
        self.token2 = token2
        self.fee = fee
    }
}
