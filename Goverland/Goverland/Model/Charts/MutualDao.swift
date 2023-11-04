//
//  MutualDao.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import SwiftUI

struct MutualDao: Decodable {
    let dao: Dao
    let votersCount: Int
    let votersPercent: Double

    enum CodingKeys: String, CodingKey {
        case dao
        case votersCount = "voters_count"
        case votersPercent = "voters_percent"
    }
}
