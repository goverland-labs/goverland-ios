//
//  UserProfile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var deviceId: String
    private(set) var selected: Bool
    private(set) var sessionId: String?
    private(set) var address: String?
    private(set) var resolvedName: String?
    private(set) var avatar: URL?

    init(deviceId: String, 
         selected: Bool,
         sessionId: String? = nil,
         address: String? = nil,
         resolvedName: String? = nil,
         avatar: URL? = nil)
    {
        self.deviceId = deviceId
        self.selected = selected
        self.sessionId = sessionId
        // TODO: update authToken
        self.address = address
        self.resolvedName = resolvedName
        self.avatar = avatar
    }

    private func setSessionId(_ sessionId: String?) {
        self.sessionId = sessionId
        if selected {
            SettingKeys.shared.authToken = sessionId ?? ""
        }
    }
}


extension UserProfile {
    //    @MainActor
    //    static var selected: UserProfile? {
    //        var fetchDescriptor = FetchDescriptor<UserProfile>(
    //            predicate: #Predicate { $0.selected }
    //        )
    //        fetchDescriptor.fetchLimit = 1
    //        if let userProfile = try? appContainer.mainContext.fetch(fetchDescriptor).first {
    //            return userProfile
    //        } else {
    //            logInfo("[UserProfile] No selected profile found.")
    //            return nil
    //        }
    //    }

    @MainActor
    static func updateSessionIdForSelectedProfile(with sessionId: String?) throws {
        var fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected }
        )
        fetchDescriptor.fetchLimit = 1
        let context = appContainer.mainContext
        if let userProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Selected profile found. Update sessionId with \(sessionId ?? "nil").")
            userProfile.setSessionId(sessionId)
            try context.save()
        } else {
            logInfo("[UserProfile] No selected profile found in updateSessionIdForSelectedProfile.")
        }
    }

    @MainActor
    static func getOrCreateGuestProfile() throws -> UserProfile {
        var fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.address == nil }
        )
        fetchDescriptor.fetchLimit = 1
        let context = appContainer.mainContext
        if let userProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Return a found GUEST profile.")
            return userProfile
        } else {
            logInfo("[UserProfile] No guest profile is found. Creating one.")
            let profile = UserProfile(deviceId: UUID().uuidString, selected: false)
            context.insert(profile)
            try context.save()
            return profile
        }
    }

    @MainActor
    func select() throws {
        var fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected }
        )
        fetchDescriptor.fetchLimit = 1
        let context = appContainer.mainContext
        if let selectedProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Selecting a new profile: \(self.address ?? "GUEST"). Prev. selected: \(selectedProfile.address ?? "GUEST")")
            selectedProfile.selected = false
            self.selected = true
            try context.save()
        } else {
            logInfo("[UserProfile] No selected profile found. Selecting \(self.address ?? "GUEST")")
            self.selected = true
            try context.save()
        }
    }
}
