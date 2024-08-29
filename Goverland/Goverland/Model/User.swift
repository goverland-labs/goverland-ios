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
                Avatar(size: .xs, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(Avatar.Size.xs.profileImageSize * 2)")!),
                Avatar(size: .s, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(Avatar.Size.s.profileImageSize * 2)")!),
                Avatar(size: .m, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(Avatar.Size.m.profileImageSize * 2)")!),
                Avatar(size: .l, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(Avatar.Size.l.profileImageSize * 2)")!),
                Avatar(size: .xl, link: URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(Avatar.Size.xl.profileImageSize * 2)")!)
            ]
        }
    }
    
    func avatar(size: Avatar.Size) -> URL {
        if let avatar = avatars.first(where: { $0.size == size }) {
            return avatar.link
        } else {
            return URL(string: "https://cdn.stamp.fyi/avatar/\(address.value)?s=\(size.profileImageSize * 2)")!
        }
    }
}

extension User {
    var username: String {
        resolvedName ?? address.checksum ?? address.short
    }
    
    var usernameShort: String {
        resolvedName ?? address.short
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.address == rhs.address
    }
}
