//
//  PublicUserProfile.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct PublicUserProfile: Decodable, Identifiable {
    let id: UUID
    let user: User
    let votedInDaos: [Dao]

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case votedInDaos = "voted_in_daos"
    }
}
