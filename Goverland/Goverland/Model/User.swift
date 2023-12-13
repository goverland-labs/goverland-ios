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

    struct Avatar: Codable {
        let size: AvatarSize
        let link: URL
    }

    enum AvatarSize: String, Codable {
        case xs
        case s
        case m
        case l

        var imageSize: CGFloat {
            switch self {
            case .xs: return 16
            case .s: return 24
            case .m: return 32
            case .l: return 40
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case address
        case resolvedName = "resolved_name"
        case avatars
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
