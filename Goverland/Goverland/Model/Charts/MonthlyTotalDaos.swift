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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.totalDaos = try container.decode(Int.self, forKey: .totalDaos)
        self.newDaos = try container.decodeIfPresent(Int.self, forKey: .newDaos) ?? 0
    }
}
