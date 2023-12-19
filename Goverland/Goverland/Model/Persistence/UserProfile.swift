//
//  UserProfile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData
import SwiftDate

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
@Model
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

    private(set) var avatarsData: Data?

    private(set) var wcSessionMetaData: Data?

    @Transient
    private var addressDescription: String {
        address.isEmpty ? "GUEST" : address
    }

    init(deviceId: String,
         sessionId: String,
         address: String,
         selected: Bool,
         resolvedName: String?,
         avatars: [User.Avatar]?,
         wcSessionMeta: WC_SessionMeta?)
    {
        self.deviceId = deviceId
        self.sessionId = sessionId
        self.address = address
        self.selected = selected
        self.resolvedName = resolvedName
        self.avatarsData = avatars?.data
        self.wcSessionMetaData = wcSessionMeta?.data
    }
}

extension UserProfile {
    var user: User {
        var avatars = [User.Avatar]()
        if let avatarsData {
            avatars = [User.Avatar].from(data: avatarsData) ?? []
        }
        return User(address: Address(address),
                    resolvedName: resolvedName,
                    avatars: avatars)
    }
}

// MARK: - Avatar extension

extension Array where Element == User.Avatar {
    var data: Data {
        return try! JSONEncoder().encode(self)
    }

    static func from(data: Data) -> [User.Avatar]? {
        if let avatars = try? JSONDecoder().decode([User.Avatar].self, from: data) {
            logInfo("[UserProfile] restored avatars array data")
            return avatars
        }
        logInfo("[UserProfile] avatars not found")
        return nil
    }
}

// MARK: - WC_SessionMeta extension

extension WC_SessionMeta {
    var data: Data {
        return try! JSONEncoder().encode(self)
    }

    static func from(data: Data) -> WC_SessionMeta? {
        if let sessionMeta = try? JSONDecoder().decode(WC_SessionMeta.self, from: data) {
            logInfo("[UserProfile] restored WC session from data")
            return sessionMeta
        }
        logInfo("[UserProfile] WC session not found")
        return nil
    }

    var isExpired: Bool {
        return session.expiryDate < .now + 5.minutes
    }
}

// MARK: - Interactions with SwiftData

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
        } else {
            logInfo("[UserProfile] No selected profile found. Selecting \(self.addressDescription)")
            self.selected = true
        }

        // Update WC_Manager in-memory session meta
        if let wcSessionMetaData, let sessionMeta = WC_SessionMeta.from(data: wcSessionMetaData) {
            if !sessionMeta.isExpired {
                logInfo("[UserProfile] Selected profile WC session restored.")
                WC_Manager.shared.sessionMeta = sessionMeta
            } else {
                logInfo("[UserProfile] Selected profile WC session is expired (valid till \(sessionMeta.session.expiryDate). Removing it.")
                self.wcSessionMetaData = nil
                WC_Manager.shared.sessionMeta = nil
            }
        } else {
            logInfo("[UserProfile] Selected profile has no WC session.")
            self.wcSessionMetaData = nil
            WC_Manager.shared.sessionMeta = nil
        }

        // Update authToken with profile sessionId
        SettingKeys.shared.authToken = self.sessionId

        try context.save()
    }

    @MainActor
    static func selected() throws -> UserProfile? {
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected }
        )
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Found selected profile.")
            return profile
        } else {
            logInfo("[UserProfile] No selected profile found.")
            return nil
        }
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
    static func signOutSelected(logErrorIfNotFound: Bool = false) throws {
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected == true }
        )
        let context = appContainer.mainContext
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Loggin out (deleting) selected profile \(profile.addressDescription).")
            context.delete(profile)
            try context.save()
        } else {
            if logErrorIfNotFound {
                logError(GError.appInconsistency(reason: "[UserProfile] Developer Error: Failed to log out (delete) `selected` profile. No selected profile found."))
            } else {
                logInfo("[UserProfile] No selected profile found to log out.")
            }
        }

        // Clean authToken but keep WalletConnect in-memory session meta
        SettingKeys.shared.authToken = ""
    }

    @MainActor
    /// Update profile metadata, excluding session, deviceId and wcSessionMetaData.
    ///
    /// - Parameter profile: Profile object. Returned by backend.
    /// - Returns: UserProfile record.
    static func softUpdateExisting(profile: Profile) throws {
        let normalizedAddress = profile.address ?? ""
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.address == normalizedAddress }
        )
        let context = appContainer.mainContext
        guard let userProfile = try context.fetch(fetchDescriptor).first else {
            logError(GError.appInconsistency(reason: "[UserProfile] Developer error. Could not find a profile for update."))
            return
        }
        logInfo("[UserProfile] Update existing user profile \(userProfile.addressDescription).")
        userProfile.resolvedName = profile.account?.resolvedName
        userProfile.avatarsData = profile.account?.avatars.data
        try context.save()
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
    static func upsert(profile: Profile,
                       deviceId: String,
                       sessionId: String,
                       wcSessionMeta: WC_SessionMeta?) throws -> UserProfile {
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
            userProfile.avatarsData = profile.account?.avatars.data
            userProfile.wcSessionMetaData = wcSessionMeta?.data
            try context.save()
            return userProfile
        }
        logInfo("[UserProfile] Create user profile \(profile.address ?? "GUEST").")
        let userProfile = UserProfile(deviceId: deviceId,
                                      sessionId: sessionId,
                                      address: normalizedAddress,
                                      selected: false,
                                      resolvedName: profile.account?.resolvedName,
                                      avatars: profile.account?.avatars, 
                                      wcSessionMeta: wcSessionMeta)
        context.insert(userProfile)
        try context.save()
        return userProfile
    }

    @MainActor
    /// Clears wcSessionMetaData for a profile.
    /// - Parameter topic: WalletConnect Session topic
    static func clear_WC_Sessions(topic: String) throws {
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let context = appContainer.mainContext
        let profiles = try appContainer.mainContext.fetch(fetchDescriptor)
        if profiles.isEmpty {
            logInfo("[UserProfile] No profiles found in clearProfile_WC_Session.")
            // Possible use case: when a user signs in, and kills the session from a wallet after establishing it.
            WC_Manager.shared.sessionMeta = nil
            return
        }

        var foundCount = 0

        for profile in profiles {
            if let data = profile.wcSessionMetaData,
                let sessionMeta = WC_SessionMeta.from(data: data), sessionMeta.session.topic == topic {
                profile.wcSessionMetaData = nil
                foundCount += 1
                if profile.selected {
                    WC_Manager.shared.sessionMeta = nil
                }
            }
        }
        if foundCount > 0 {
            logInfo("[UserProfile] Removed all sessions with topic \(topic). Found profiles: \(foundCount)")
            try context.save()
        } else {
            logInfo("[UserProfile] No profile with WC topic \(topic) found.")
        }
    }

    @MainActor
    /// Update stored session in selected profile with a value from cached session meta.
    /// It is used when reconnecting an expired session for the selected profile.
    static func update_WC_SessionForSelectedProfile() throws {
        let sessionMeta = WC_Manager.shared.sessionMeta
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected == true }
        )
        let context = appContainer.mainContext
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Updating WC session for selected profile \(profile.addressDescription).")
            profile.wcSessionMetaData = sessionMeta?.data
            try context.save()
        } else {
            logError(GError.appInconsistency(reason: "[UserProfile] No selected profile found to update WC session."))
        }
    }
}
