//
//  Pool.swift
//  UniswapKit
//
//  Created by Sun on 2023/5/8.
//

import Foundation

import EVMKit
import SWToolKit

// MARK: - Pool

class Pool {
    // MARK: Properties

    let poolAddress: Address

    private let networkManager: NetworkManager
    private let rpcSource: RpcSource
    private let token0: Address
    private let token1: Address
    private let fee: KitV3.FeeAmount

    // MARK: Lifecycle

    init(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        chain: Chain,
        token0: Address,
        token1: Address,
        fee: KitV3.FeeAmount,
        dexType: DEXType
    ) async throws {
        self.networkManager = networkManager
        self.rpcSource = rpcSource
        self.token0 = token0
        self.token1 = token1
        self.fee = fee

        let method = GetPoolMethod(token0: token0, token1: token1, fee: fee.rawValue)

        let poolData = try await Self.call(
            networkManager: networkManager, rpcSource: rpcSource,
            address: dexType.factoryAddress(chain: chain),
            data: method.encodedABI()
        )

        guard poolData.count >= 32 else {
            throw PoolError.cantCreateAddress
        }

        poolAddress = Address(raw: poolData[0 ..< 32])
    }

    // MARK: Static Functions

    private static func call(
        networkManager: NetworkManager,
        rpcSource: RpcSource,
        address: Address,
        data: Data
    ) async throws
        -> Data {
        do {
            return try await EVMKit.Kit.call(
                networkManager: networkManager,
                rpcSource: rpcSource,
                contractAddress: address,
                data: data
            )
        } catch {
            throw error
        }
    }
}

extension Pool {
    public func slot0() async throws -> Slot0 {
        let method = Slot0Method()
        let data = try await Self.call(
            networkManager: networkManager,
            rpcSource: rpcSource,
            address: poolAddress,
            data: method.encodedABI()
        )

        guard let slot0 = Slot0(data: data) else {
            throw PoolError.cantFetchSlot0
        }

        return slot0
    }

    public func token0() async throws -> String {
        let method = Token0Method()
        let data = try await Self.call(
            networkManager: networkManager,
            rpcSource: rpcSource,
            address: poolAddress,
            data: method.encodedABI()
        )

        return Address(raw: data).hex
    }

    enum PoolError: Error {
        case cantCreateAddress
        case cantFetchSlot0
        case cantFetchToken0
    }
}
