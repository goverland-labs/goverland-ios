//
//  UserDelegation.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct UserDelegate: Decodable, Identifiable {
    let id: UUID = UUID()
    let delegate: User
    let percentDelegated: Double
    let expiration: Date?

    enum CodingKeys: String, CodingKey {
        case delegate = "user"
        case percentDelegated = "percent_of_delegated"
        case expiration
    }
}

struct UserDaoDelegates: Decodable, Identifiable {
    let dao: Dao
    let delegates: [UserDelegate]
    
    var id: UUID {
        dao.id
    }
}

struct UserDelegator: Decodable, Identifiable {
    let id: UUID = UUID()
    let delegator: User
    let percentDelegated: Double
    let expiration: Date?

    enum CodingKeys: String, CodingKey {
        case delegator = "user"
        case percentDelegated = "percent_of_delegated"
        case expiration
    }
}

struct UserDaoDelegators: Decodable, Identifiable {
    let dao: Dao
    let delegators: [UserDelegator]
    
    var id: UUID {
        dao.id
    }
}
