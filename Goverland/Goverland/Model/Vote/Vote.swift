//
//  Vote.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

struct Vote<ChoiceType: Decodable>: Identifiable, Decodable {
    let id: String
    let voter: User
    let votingPower: Double
    let choice: ChoiceType
    let message: String?
    
    init(id: String,
         voter: User,
         votingPower: Double,
         choice: ChoiceType,
         message: String?) {
        self.id = id
        self.voter = voter
        self.votingPower = votingPower
        self.choice = choice
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case voter
        case votingPower = "vp"
        case choice
        case message = "reason"
    }
}

struct VoteSubmission: Decodable {
    let id: String
    let ipfs: String
}
