//
//  TopVoter.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct TopVoter: Decodable {
    let voter: User
    let votingPower: Double
    let votesCount: Double

    enum CodingKeys: String, CodingKey {
        case voter
        case votingPower = "vp_avg"
        case votesCount = "votes_count"
    }
}

extension TopVoter: Identifiable {
    var id: String {
        voter.address.description
    }
}
