//
//  Dao_AVP_Bins.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct DaoAvpBins: Decodable {
    let vpUsdValue: Double
    let votersCutted: Int
    let votersTotal: Int
    let avpUsdTotal: Double
    let bins: [Bin]

    struct Bin: Decodable {
        let upperBound: Double
        let count: Int
        let totalAvpUsd: Double

        enum CodingKeys: String, CodingKey {
            case upperBound = "upper_bound_usd"
            case count
            case totalAvpUsd = "total_avp_usd"
        }
    }

    enum CodingKeys: String, CodingKey {
        case vpUsdValue = "vp_usd_value"
        case votersCutted = "voters_cutted"
        case votersTotal = "voters_total"
        case avpUsdTotal = "avp_usd_total"
        case bins
    }
}
