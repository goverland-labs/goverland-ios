//
//  Subscription.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-13.
//

import Foundation

struct Subscription: Decodable {
    let id: UUID
    let createdAt: Date
    let dao: Dao
}

struct SubscriptionMeta: Decodable, Equatable {
    let id: UUID
    let createdAt: Date
}

