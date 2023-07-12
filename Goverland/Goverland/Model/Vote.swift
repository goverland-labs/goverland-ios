//
//  Vote.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//

import SwiftUI

// TODO: this is a stab
struct Vote: Identifiable, Decodable {
    let id: UUID
    let voter: User
    let votingPower: Double
    let choice: String
    let message: String?
    
    init(id: UUID,
         voter: User,
         votingPower: Double,
         choice: String,
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.voter = try container.decode(User.self, forKey: .voter)
        self.votingPower = try container.decode(Double.self, forKey: .votingPower)
        self.choice = try container.decode(String.self, forKey: .choice)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
