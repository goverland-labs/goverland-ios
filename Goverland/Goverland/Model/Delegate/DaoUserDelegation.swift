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

struct DaoUserDelegationRequest: Encodable {
    let chainId: Int
    let delegates: [RequestDelegate]
    let expirationDate: Date?

    enum CodingKeys: String, CodingKey {
        case chainId = "chain_id"
        case delegates
        case expirationDate = "expiration_date"
    }

    struct RequestDelegate: Encodable {
        let address: String
        let percentOfDelegated: Double

        enum CodingKeys: String, CodingKey {
            case address
            case percentOfDelegated = "percent_of_delegated"
        }
    }
}

struct DaoUserDelegationPreparedData: Decodable {
    let to: String
    let data: String
    let gasPrice: String
    let gas: String
    let maxPriorityFeePerGas: String?
    let maxFeePerGas: String?

    enum CodingKeys: String, CodingKey {
        case to
        case data
        case gasPrice = "gas_price"
        case gas
        case maxPriorityFeePerGas = "max_priority_fee_per_gas"
        case maxFeePerGas = "max_fee_per_gas"
    }
}
