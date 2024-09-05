//
//  DelegateVotingPower.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct DelegateVotingPower: Codable, Identifiable {
    let user: User
    let powerPercent: Double
    let powerRatio: Int
    
    var id: String {
        user.address.value
    }
    
    enum CodingKeys: String, CodingKey {
        case user
        case powerPercent = "percent_of_delegated"
        case powerRatio = "weight"
    }
}
