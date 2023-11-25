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
    static let profileKey = "xyz.goverland.profile"

    static var cached: Profile? {
        if let encoded = UserDefaults.standard.data(forKey: Self.profileKey) {
            do {
                return try JSONDecoder().decode(Profile.self, from: encoded)
            } catch {
                logInfo("[Profile] cached profile decoding error: \(error.localizedDescription)")
                return nil
            }
        }
        logInfo("[Profile] No cached profile found.")
        return nil
    }

    static func clearCache() {
        UserDefaults.standard.removeObject(forKey: Self.profileKey)
        logInfo("[Profile] cleared cache")
    }

    func cache() {
        let encoded = try! JSONEncoder().encode(self)
        UserDefaults.standard.set(encoded, forKey: Self.profileKey)
        logInfo("[Profile] cached: \(self)")
    }
}

// MARK: - Stub

extension Profile {
    static let testRegular = Profile(
        role: .regular,
        accounts: [.flipside],
        sessions: [])
}
