//
//  MonthlyTotalNewProposals.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MonthlyTotalNewProposals: Decodable {
    let date: Date
    let newProposals: Int

    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case newProposals = "total"
    }
}
