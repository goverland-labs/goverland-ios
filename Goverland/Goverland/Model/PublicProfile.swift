//
//  PublicProfile.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct PublicProfile: Decodable, Identifiable {
    let id: UUID
    let user: User
    let votes: [Proposal]
    let daos: [Dao]
}
