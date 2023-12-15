//
//  Profile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Profile: Codable {
    let id: UUID
    let role: Role
    let account: User?
    let sessions: [Session]

    enum Role: String, Codable {
        case guest = "guest"
        case regular = "regular"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case role
        case account
        case sessions = "last_sessions"
    }
}

struct Session: Codable, Identifiable {
    let id: UUID
    let created: Date
    let lastActivity: Date
    let deviceId: String
    let deviceName: String

    enum CodingKeys: String, CodingKey {
        case id = "session_id"
        case created = "created_at"
        case lastActivity = "last_activity_at"
        case deviceId = "device_id"
        case deviceName = "device_name"
    }
}

extension Profile {
    var address: String? {
        // don't change for UserProfile model consistency
        account?.address.value.lowercased()
    }
}
