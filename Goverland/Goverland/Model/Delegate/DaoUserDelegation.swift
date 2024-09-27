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
}

struct DaoUserDelegationRequest: Encodable {
    let chainId: Int
    let txHash: String?
    let delegates: [RequestDelegate]
    let expirationDate: Date?

    enum CodingKeys: String, CodingKey {
        case chainId = "chain_id"
        case txHash = "tx_hash"
        case delegates
        case expirationDate = "expiration_date"
    }

    struct RequestDelegate: Encodable {
        let address: String
        let resolvedName: String?
        let percentOfDelegated: Double

        enum CodingKeys: String, CodingKey {
            case address
            case resolvedName = "resolved_name"
            case percentOfDelegated = "percent_of_delegated"
        }
    }

    func with(txHash: String) -> Self {
        Self(chainId: self.chainId,
             txHash: txHash,
             delegates: self.delegates,
             expirationDate: self.expirationDate)
    }
}

struct DaoUserDelegationPreparedData: Decodable {
    let to: String
    let data: String
    let gas: String
    let maxPriorityFeePerGas: String
    let maxFeePerGas: String

    enum CodingKeys: String, CodingKey {
        case to
        case data
        case gas
        case maxPriorityFeePerGas = "max_priority_fee_per_gas"
        case maxFeePerGas = "max_fee_per_gas"
    }
}
