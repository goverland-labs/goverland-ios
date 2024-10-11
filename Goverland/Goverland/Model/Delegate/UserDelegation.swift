//
//  UserDelegation.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct UserDelegate: Decodable, Identifiable {
    let id: UUID
    let delegate: User
    let percentDelegated: Double
    let expiresAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case delegate
        case percentDelegated = "percent_of_delegated"
        case expiresAt = "expires_at"
    }
}

struct UserDaoDelegates: Decodable, Identifiable {
    let id: UUID
    let dao: Dao
    let delegates: [UserDelegate]
}

struct UserDelegator: Decodable, Identifiable {
    let id: UUID
    let delegator: User
    let votingPower: Double

    enum CodingKeys: String, CodingKey {
        case id
        case delegator
        case votingPower = "voting_power"
    }
}

struct UserDaoDelegators: Decodable, Identifiable {
    let id: UUID
    let dao: Dao
    let delegators: [UserDelegator]
}
