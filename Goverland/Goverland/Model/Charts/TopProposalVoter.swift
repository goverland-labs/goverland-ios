//
//  TopProposalVoter.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct TopProposalVoter: VoterVotingPower, Decodable {
    let voter: User
    let votingPower: Double

    var id: String {
        voter.address.description
    }

    enum CodingKeys: String, CodingKey {
        case voter
        case votingPower = "vp"
    }
}
