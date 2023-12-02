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
/// Model to store user profiles.
/// The App can have one guest profile and many profiles attached to different addresses.
/// In the future we potentially can make the app multi-profile, meaning a user can switch between profiles easily.
///
/// A profile record is created:
/// -- Once a guest user created a session.
/// -- Once a regular user signed it.
///
/// A profile record is deleted:
/// -- Once a user deleted profile in Settings.
/// -- Once a user signed out or got a 401 backend response (forced signing out).
///
final class UserProfile {
    /// `deviceId` is a random number that is associated this profile on this device.
    /// We use it not to link profiles between each other.
    @Attribute(.unique) private(set) var deviceId: String
    @Attribute(.unique) private(set) var sessionId: String
    /// If `address` is empty, then this is a guest profile. There can be only one guest profile on device.
    @Attribute(.unique) private(set) var address: String

    /// Only one profile can be selected at once.
    private(set) var selected: Bool
    private(set) var resolvedName: String?
    private(set) var avatar: URL?

    private var addressDescription: String {
        address.isEmpty ? "GUEST" : address
    }

    init(deviceId: String,
         sessionId: String,
         address: String,
         selected: Bool,
         resolvedName: String?,
         avatar: URL?)
    {
        self.deviceId = deviceId
        self.sessionId = sessionId
        self.address = address
        self.selected = selected
        self.resolvedName = resolvedName
        self.avatar = avatar
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
            logInfo("[UserProfile] Selecting a new profile: \(self.addressDescription). Prev. selected: \(selectedProfile.addressDescription)")
            selectedProfile.selected = false
            self.selected = true
            try context.save()
        } else {
            logInfo("[UserProfile] No selected profile found. Selecting \(self.addressDescription)")
            self.selected = true
            try context.save()
        }

        // Update authToken with profile sessionId
        SettingKeys.shared.authToken = self.sessionId
    }

    @MainActor
    static func getByAddress(_ address: String) throws -> UserProfile? {
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.address == address }
        )
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Found a profile by address \(profile.addressDescription).")
            return profile
        } else {
            logInfo("[UserProfile] No profile found by address \(address.isEmpty ? "GUEST" : address).")
            return nil
        }
    }

    @MainActor
    // TODO: In the future select the next available profile.
    static func logoutSelected() throws {
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected == true }
        )
        let context = appContainer.mainContext
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Loggin out (deleting) selected profile \(profile.addressDescription).")
            context.delete(profile)
            try context.save()
        } else {
            logError(GError.appInconsistency(reason: "[UserProfile] Developer Error: Failed to log out (delete) `selected` profile. No selected profile found."))
        }

        // Clean authToken
        SettingKeys.shared.authToken = ""
    }

    @MainActor
    /// Update profile metadata, excluding session & deviceId.
    ///
    /// - Parameter profile: Profile object. Returned by backend.
    /// - Returns: UserProfile record.
    static func softUpdateExisting(profile: Profile) throws -> UserProfile {
        let normalizedAddress = profile.address ?? ""
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.address == normalizedAddress }
        )
        let context = appContainer.mainContext
        guard let userProfile = try context.fetch(fetchDescriptor).first else {
            fatalError("[UserProfile] Developer error. Could not find a profile for update.")
        }
        logInfo("[UserProfile] Update existing user profile \(userProfile.addressDescription).")
        userProfile.address = normalizedAddress
        userProfile.resolvedName = profile.account?.resolvedName
        userProfile.avatar = profile.account?.avatar
        try context.save()
        return userProfile
    }

    @MainActor
    /// We do not take session from Profile object just in case, to reduce complecations that might happen when we have multiple devices.
    /// Therefore we pass it from a caller. Similar with deviceId.
    ///
    /// - Parameters:
    ///   - profile: Profile object. Returned by backend.
    ///   - deviceId: Passed from a caller. It is a unique string associated with session.
    ///   - sessionId: Passed from a caller. Returned by backend.
    /// - Returns: UserProfile record.
    static func upsert(profile: Profile, deviceId: String, sessionId: String) throws -> UserProfile {
        let normalizedAddress = profile.address ?? ""
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.address == normalizedAddress }
        )
        let context = appContainer.mainContext
        if let userProfile = try context.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Update existing user profile \(userProfile.addressDescription).")
            userProfile.deviceId = deviceId
            userProfile.sessionId = sessionId
            userProfile.address = normalizedAddress
            userProfile.resolvedName = profile.account?.resolvedName
            userProfile.avatar = profile.account?.avatar
            try context.save()
            return userProfile
        }
        logInfo("[UserProfile] Create user profile \(profile.address ?? "GUEST").")
        let userProfile = UserProfile(deviceId: deviceId,
                                      sessionId: sessionId,
                                      address: normalizedAddress,
                                      selected: false,
                                      resolvedName: profile.account?.resolvedName,
                                      avatar: profile.account?.avatar)
        context.insert(userProfile)
        try context.save()
        return userProfile
    }
}
