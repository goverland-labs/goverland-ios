//
//  Vote.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//

import SwiftUI

// TODO: this is a stab
struct Vote: Identifiable, Decodable {
    let id: String
    let voter: User
    let votingPower: Double
    let choice: Int
    let message: String?
    
    init(id: String,
         voter: User,
         votingPower: Double,
         choice: Int,
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
