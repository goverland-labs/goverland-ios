//
//  MonthlyTotalDaos.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MonthlyTotalDaos: Decodable {
    let date: Date
    let totalDaos: Int
    let newDaos: Int

    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case totalDaos = "total"
        case newDaos = "total_of_new"
    }
}
