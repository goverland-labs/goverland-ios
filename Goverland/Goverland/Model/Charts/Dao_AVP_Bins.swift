//
//  Dao_AVP_Bins.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Dao_AVP_Bins: Decodable {
    let vp_USD_Value: Double
    let votersCutted: Int
    let votersTotal: Int
    let bins: [Bin]

    struct Bin: Decodable {
        let upperBound: Double
        let count: Int

        enum CodingKeys: String, CodingKey {
            case upperBound = "upper_bound"
            case count
        }
    }

    enum CodingKeys: String, CodingKey {
        case vp_USD_Value = "vp_usd_value"
        case votersCutted = "voters_cutted"
        case votersTotal = "voters_total"
        case bins
    }
}
