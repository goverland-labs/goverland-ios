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
    /// `deviceId` is a random number that is associated this profile on this device.
    /// We use it not to link profiles between each other.
    @Attribute(.unique) private(set) var deviceId: String
    /// Only one profile can be selected at once.
    private(set) var selected: Bool
    /// If `id` is nil, then this is a guest profile. There can be only one guest profile on device.
    @Attribute(.unique) private(set) var id: UUID?
    /// If `address` is nil, then this is a guest profile. There can be only one guest profile on device.
    @Attribute(.unique) private(set) var address: String?
    private(set) var sessionId: String?
    private(set) var resolvedName: String?
    private(set) var avatar: URL?

    init(deviceId: String,
         selected: Bool,
         id: UUID? = nil,
         address: String? = nil,
         sessionId: String? = nil,
         resolvedName: String? = nil,
         avatar: URL? = nil)
    {
        self.deviceId = deviceId
        self.selected = selected
        self.id = id
        self.address = address
        self.sessionId = sessionId
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

        // Update authToken with profile sessionId
        SettingKeys.shared.authToken = self.sessionId ?? ""
    }

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
            predicate: #Predicate { $0.id == nil }
        )
        fetchDescriptor.fetchLimit = 1
        let context = appContainer.mainContext
        if let guestProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Return a found GUEST profile.")
            return guestProfile
        } else {
            logInfo("[UserProfile] No guest profile is found. Creating one.")
            let guestProfile = UserProfile(deviceId: UUID().uuidString, selected: false)
            context.insert(guestProfile)
            try context.save()
            return guestProfile
        }
    }

    @MainActor
    static func update(with profile: Profile, 
                       sessionId: String? = nil) throws {
        var fetchDescriptor: FetchDescriptor<UserProfile>
        switch profile.role {
        case .guest:
            // Stored guest profiles will never have an address
            fetchDescriptor = FetchDescriptor<UserProfile>(
                predicate: #Predicate { $0.address == nil }
            )
        case .regular:
            // Stored regular profiles will always have an id
            let optionalId = Optional(profile.id)
            fetchDescriptor = FetchDescriptor<UserProfile>(
                predicate: #Predicate { $0.id == optionalId }
            )
        }

        let context = appContainer.mainContext
        if let userProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Update user profile with \(profile).")
            userProfile.id = profile.id
            userProfile.address = profile.account?.address.value
            userProfile.resolvedName = profile.account?.resolvedName
            userProfile.avatar = profile.account?.avatar
            if let sessionId {
                userProfile.sessionId = sessionId
            }
            try context.save()
        } else {
            logError(GError.appInconsistency(reason: "[UserProfile] Could not find a profile for update."))
        }
    }
}
