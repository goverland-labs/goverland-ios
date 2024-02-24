//
//  TopVoter.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct TopVoter: Decodable, Identifiable {
    let id: String
    let name: Address
    let votingPower: Double
    let votesCount: Double

    enum CodingKeys: String, CodingKey {
        case name = "voter"
        case voterPower = "vp_avg"
        case voterCount = "votes_count"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(Address.self, forKey: .name)
            self.votingPower = try container.decode(Double.self, forKey: .voterPower)
            self.votesCount = try container.decode(Double.self, forKey: .voterCount)
            self.id = name.description
        }
    
    init(name: Address, votingPower: Double, votesCount: Double) {
        self.id = name.value
            self.name = name
            self.votingPower = votingPower
            self.votesCount = votesCount
        }
}
