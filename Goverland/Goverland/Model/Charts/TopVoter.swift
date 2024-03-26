//
//  TopVoter.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct TopVoter: VoterVotingPower, Decodable {
    let voter: User
    let votingPower: Double
    let votesCount: Double

    var id: String {
        voter.address.description
    }

    init(voter: User, votingPower: Double) {
        self.voter = voter
        self.votingPower = votingPower
        self.votesCount = 0
    }

    enum CodingKeys: String, CodingKey {
        case voter
        case votingPower = "vp_avg"
        case votesCount = "votes_count"
    }
}
