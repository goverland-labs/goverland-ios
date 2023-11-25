//
//  Profile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct Profile: Codable {
    let role: Role
    let accounts: [User]
    let sessions: [Session]

    enum Role: String, Codable {
        case guest
        case regular
    }
}

struct Session: Codable, Identifiable {
    let id: UUID
    let device: String
    let created: Date
    let lastActivity: Date

    enum CodingKeys: String, CodingKey {
        case id
        case device
        case created = "created_at"
        case lastActivity = "last_activity_at"
    }
}

extension Profile {
    var address: String {
        accounts.first?.address.value ?? ""
    }
}

// MARK: - Stub

extension Profile {
    static let testRegular = Profile(
        role: .regular,
        accounts: [.flipside],
        sessions: [])
}
