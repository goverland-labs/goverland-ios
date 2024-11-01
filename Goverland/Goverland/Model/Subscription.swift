//
//  Subscription.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-13.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

struct Subscription: Decodable, Identifiable {
    let id: UUID
    let createdAt: Date
    let dao: Dao

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case dao
    }
}

struct SubscriptionMeta: Decodable, Equatable {
    let id: UUID
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
}
