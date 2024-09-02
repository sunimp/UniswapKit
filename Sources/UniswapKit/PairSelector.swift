//
//  PairSelector.swift
//
//  Created by Sun on 2020/7/11.
//

import Foundation

import EVMKit

class PairSelector {
    // MARK: Properties

    private let tokenFactory: TokenFactory

    // MARK: Lifecycle

    init(tokenFactory: TokenFactory) {
        self.tokenFactory = tokenFactory
    }

    // MARK: Functions

    func tokenPairs(chain: Chain, tokenA: Token, tokenB: Token) throws -> [(Token, Token)] {
        if tokenA.isEther || tokenB.isEther {
            return [(tokenA, tokenB)]
        } else {
            let etherToken = try tokenFactory.etherToken(chain: chain)

            return [(tokenA, tokenB), (tokenA, etherToken), (tokenB, etherToken)]
        }
    }
}
