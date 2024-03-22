//
//  MonthlyNewProposals.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct MonthlyNewProposals: Decodable {
    let date: Date
    let count: Int
    let spamCount: Int

    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case count = "proposals_count"
        case spamCount = "spam_count"
    }
}
