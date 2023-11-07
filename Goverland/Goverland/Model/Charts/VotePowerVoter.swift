//
//  VotePowerVoter.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct VotePowerVoter: Decodable {
    let name: Address
    let voterPower: Double
    let voterCount: Double

    enum CodingKeys: String, CodingKey {
        case name = "voter"
        case voterPower = "vp_avg"
        case voterCount = "votes_count"
    }
}
