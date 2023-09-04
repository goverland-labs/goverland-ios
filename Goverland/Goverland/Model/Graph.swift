//
//  Graph.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-04.
//

import SwiftUI

struct Graph: Decodable {
    let date: Date
    let activeUsers: Double
    let newUsers: Double
    
    init(date: Date,
         activeUsers: Double,
         newUsers: Double) {
        self.date = date
        self.activeUsers = activeUsers
        self.newUsers = newUsers
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "period_started"
        case activeUsers = "active_users"
        case newUsers = "new_active_users"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.activeUsers = try container.decode(Double.self, forKey: .activeUsers)
        self.newUsers = try container.decode(Double.self, forKey: .newUsers)
    }
}

