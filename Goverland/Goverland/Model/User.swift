//
//  User.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct User: Codable {
    let address: Address
    let resolvedName: String?
    let avatars: [Avatar]

    init(address: Address, resolvedName: String?, avatars: [Avatar]) {
        self.address = address
        self.resolvedName = resolvedName
        self.avatars = avatars
    }

    enum CodingKeys: String, CodingKey {
        case address
        case resolvedName = "resolved_name"
        case avatars
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decode(Address.self, forKey: .address)
        self.resolvedName = try container.decodeIfPresent(String.self, forKey: .resolvedName)
        // falback
        if let avatars = try container.decodeIfPresent([Avatar].self, forKey: .avatars) {
            self.avatars = avatars
        } else {
            self.avatars = [
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=32")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=52")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=92")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=152")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=180")!)
            ]
        }
    }
}

extension User {
    static var flipside: User {
        User(address: Address("0x62a43123FE71f9764f26554b3F5017627996816a"),
             resolvedName: "flipsidecrypto.eth",
             avatars: [])
    }

    static var aaveChan: User {
        User(address: Address("0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4"),
             resolvedName: "aavechan.eth",
             avatars: [
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/eth:0x329c54289Ff5D6B7b7daE13592C6B1EDA1543eD4?s=138")!)
             ])
    }

    static var test: User {
        User(address: Address("0x46F228b5eFD19Be20952152c549ee478Bf1bf36b"),
             resolvedName: nil,
             avatars: [])
    }
}
