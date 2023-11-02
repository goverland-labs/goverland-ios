//
//  MutualDao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import SwiftUI

struct MutualDao: Decodable {
    let voter: String
    let vp_avg: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case voter
        case vp_avg = "vp_avg"
        case count = "votes_count"
    }
}
