//
//  DaoUserDelegation.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct DaoUserDelegation: Decodable {
    let dao: Dao
    let votingPower: VotingPower
    let chains: Chains
    let delegates: [DelegateVotingPower]
    let expirationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case dao
        case votingPower = "voting_power"
        case chains
        case delegates
        case expirationDate = "expiration_date"
    }
    
    struct VotingPower: Decodable {
        let symbol: String
        let power: Double
    }
}

extension DaoUserDelegation {
    static let testUserDelegation = DaoUserDelegation(dao: .aave, 
                                                      votingPower: .init(symbol: "UTI", power: 12.5),
                                                      chains: .testChains,
                                                      delegates: [.delegateAaveChan, .delegateFlipside],
                                                      expirationDate: nil)
}
