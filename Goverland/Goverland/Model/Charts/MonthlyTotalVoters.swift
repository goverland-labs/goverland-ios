//
//  MonthlyTotalVoters.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-12-05.
//  Copyright © Goverland Inc. All rights reserved.
//
	
import SwiftUI

struct MonthlyTotalVoters: Decodable {
    let date: Date
    let totalVoters: Int
    let newVoters: Int

    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case totalVoters = "total"
        case newVoters = "total_of_new"
    }
}
