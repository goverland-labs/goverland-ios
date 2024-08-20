//
//  Chains.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Chains: Decodable {
    let eth: Chain
    let gnosis: Chain
}

extension Chains {
    static let testChains = Chains(eth: .etherium, gnosis: .gnosis)
}
