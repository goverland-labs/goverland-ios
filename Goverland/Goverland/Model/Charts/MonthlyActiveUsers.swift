//
//  MonthlyActiveUsers.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-04.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct MonthlyActiveUsers: Decodable {
    let date: Date
    let activeUsers: Int
    let newUsers: Int

    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case activeUsers = "active_users"
        case newUsers = "new_active_users"
    }
}
