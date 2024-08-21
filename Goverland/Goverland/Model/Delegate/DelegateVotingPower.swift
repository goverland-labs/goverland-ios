//
//  DelegateVotingPower.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct DelegateVotingPower: Decodable {
    let user: User
    let powerPercent: Double
    let powerRatio: Int
    
    enum CodingKeys: String, CodingKey {
        case user
        case powerPercent = "percent_of_delegated"
        case powerRatio = "ratio"
    }
}

extension DelegateVotingPower {
    static let delegateAaveChan = DelegateVotingPower(user: .aaveChan,
                                                      powerPercent: 33.3,
                                                      powerRatio: 2)
    static let delegateFlipside = DelegateVotingPower(user: .flipside,
                                                      powerPercent: 66.6,
                                                      powerRatio: 1)
}
