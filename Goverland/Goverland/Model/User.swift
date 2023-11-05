//
//  User.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct User: Decodable {
    let address: Address
    let resolvedName: String?
    let avatar: URL?

    enum CodingKeys: String, CodingKey {
        case address
        case resolvedName = "resolved_name"
        case avatar
    }
}

extension User {
    static var flipside: User {
        User(address: Address("0x62a43123FE71f9764f26554b3F5017627996816a"),
             resolvedName: "flipsidecrypto.eth",
             avatar: nil)
    }

    static var aaveChan: User {
        User(address: Address("0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4"),
             resolvedName: "aavechan.eth",
             avatar: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138"))
    }

    static var test: User {
        User(address: Address("0x46F228b5eFD19Be20952152c549ee478Bf1bf36b"),
             resolvedName: nil,
             avatar: nil)
    }
}
