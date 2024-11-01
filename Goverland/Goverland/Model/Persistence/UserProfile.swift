//
//  UserProfile.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData
import CoinbaseWalletSDK

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
    private(set) var deviceId: String
    @Attribute(.unique) private(set) var sessionId: String
    /// If `address` is empty, then this is a guest profile. There can be only one guest profile on device.
    @Attribute(.unique) private(set) var address: String

    /// Only one profile can be selected at once.
    private(set) var selected: Bool

    private(set) var resolvedName: String?

    private(set) var avatarsData: Data?

    private(set) var subscriptionsCount: Int

    private(set) var wcSessionMetaData: Data?

    private(set) var cbAccountData: Data?

    @Transient
    private var addressDescription: String {
        address.isEmpty ? "GUEST" : address
    }

    init(deviceId: String,
         sessionId: String,
         address: String,
         selected: Bool,
         resolvedName: String?,
         avatars: [Avatar]?,
         subscriptionsCount: Int,
         wcSessionMeta: WC_SessionMeta?,
         cbAccount: Account?)
    {
        self.deviceId = deviceId
        self.sessionId = sessionId
        self.address = address
        self.selected = selected
        self.resolvedName = resolvedName
        self.avatarsData = avatars?.data
        self.subscriptionsCount = subscriptionsCount
        self.wcSessionMetaData = wcSessionMeta?.data
        self.cbAccountData = cbAccount?.data
    }
}

extension UserProfile {
    var user: User {
        var avatars = [Avatar]()
        if let avatarsData {
            avatars = [Avatar].from(data: avatarsData) ?? []
        }
        return User(address: Address(address),
                    resolvedName: resolvedName,
                    avatars: avatars)
    }

    var isGuest: Bool {
        address.isEmpty
    }

    var isRegular: Bool {
        !isGuest
    }
}

// MARK: - Avatar extension

extension Array where Element == Avatar {
    var data: Data {
        return try! JSONEncoder().encode(self)
    }

    static func from(data: Data) -> [Avatar]? {
        if let avatars = try? JSONDecoder().decode([Avatar].self, from: data) {            
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
        logInfo("[UserProfile] WC session could not be restored from provided data")
        return nil
    }
}

// MARK: - Coinbase Wallet Account extension

extension Account {
    var data: Data {
        return try! JSONEncoder().encode(self)
    }

    static func from(data: Data) -> Account? {
        if let account = try? JSONDecoder().decode(Account.self, from: data) {
            logInfo("[UserProfile] restored Coinbase Wallet account from data")
            return account
        }
        logInfo("[UserProfile] Coinbase Wallet account could not be restored from provided data")
        return nil
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

        // Update Coinbase Wallet in-memory account
        if let cbAccountData, let account = Account.from(data: cbAccountData) {
            logInfo("[UserProfile] Selected profile Coinbase Wallet account restored.")
            CoinbaseWalletManager.shared.account = account
        } else {
            logInfo("[UserProfile] Selected profile has no Coinbase Wallet account.")
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
        // Clean authToken and WalletConnect/Coinbase Wallet in-memory session meta
        SettingKeys.shared.authToken = ""
        if let sessionMeta = WC_Manager.shared.sessionMeta {
            WC_Manager.disconnect(topic: sessionMeta.session.topic)
        }
        if CoinbaseWalletManager.shared.account != nil {
            CoinbaseWalletManager.disconnect()
        }

        // Delete profile
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected == true }
        )
        let context = appContainer.mainContext
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Signing out (deleting) selected profile \(profile.addressDescription).")
            context.delete(profile)
            try context.save()
        } else {
            if logErrorIfNotFound {
                logError(GError.appInconsistency(reason: "[UserProfile] Developer Error: Failed to log out (delete) `selected` profile. No selected profile found."))
            } else {
                logInfo("[UserProfile] No selected profile found to log out.")
            }
        }
    }

    @MainActor
    /// Update profile metadata, excluding session, deviceId, wcSessionMetaData and cbAccountData.
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
        userProfile.subscriptionsCount = profile.subscriptionsCount
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
    ///   - wcSessionMeta: Meta-information about WalletConnect session
    ///   - cbAccount: Coinbase Wallet Account of this profile
    /// - Returns: UserProfile record.
    static func upsert(profile: Profile,
                       deviceId: String,
                       sessionId: String,
                       wcSessionMeta: WC_SessionMeta?,
                       cbAccount: Account?) throws -> UserProfile {
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
            userProfile.subscriptionsCount = profile.subscriptionsCount
            userProfile.wcSessionMetaData = wcSessionMeta?.data
            userProfile.cbAccountData = cbAccount?.data
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
                                      subscriptionsCount: profile.subscriptionsCount,
                                      wcSessionMeta: wcSessionMeta, 
                                      cbAccount: cbAccount)
        context.insert(userProfile)
        try context.save()
        return userProfile
    }

    @MainActor
    /// Clears wcSessionMetaData for profiles.
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
    /// Clears cbAccountData for profiles.
    static func clearCoinbaseAccounts() throws {
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let context = appContainer.mainContext
        let profiles = try appContainer.mainContext.fetch(fetchDescriptor)
        if profiles.isEmpty {
            logInfo("[UserProfile] No profiles found in clearCoinbaseAccounts.")
            CoinbaseWalletManager.shared.account = nil
            return
        }

        var foundCount = 0

        for profile in profiles {
            if let data = profile.cbAccountData {
                profile.cbAccountData = nil
                foundCount += 1
                if profile.selected {
                    CoinbaseWalletManager.shared.account = nil
                }
            }
        }

        if foundCount > 0 {
            logInfo("[UserProfile] Removed all Coinbase Wallet accounts from profiles. Found profiles: \(foundCount)")
            try context.save()
        } else {
            logInfo("[UserProfile] No profile with Coinbase Wallet account found.")
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

    @MainActor
    /// Update stored account in selected profile with a value from connected Coinbase Wallet account.
    /// It is used when reconnecting an expired session for the selected profile.
    static func updateCoinbaseWalletAccountForSelectedProfile() throws {
        let account = CoinbaseWalletManager.shared.account
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.selected == true }
        )
        let context = appContainer.mainContext
        if let profile = try appContainer.mainContext.fetch(fetchDescriptor).first {
            logInfo("[UserProfile] Updating Coinbase Wallet account for selected profile \(profile.addressDescription).")
            profile.cbAccountData = account?.data
            try context.save()
        } else {
            logError(GError.appInconsistency(reason: "[UserProfile] No selected profile found to update Coinbase Wallet account."))
        }
    }
}
