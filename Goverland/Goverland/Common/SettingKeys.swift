//
//  SettingKeys.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import SwiftUI

class SettingKeys: ObservableObject {
    /// We need to store authToken in user defaults for convenience as
    /// UserProfile @Model `.sessionId` property can be accesses only asynchronously.
    /// it leads to usage difficulties in many places.
    @AppStorage("authToken") var authToken = "" {
        didSet {
            NotificationCenter.default.post(name: .authTokenChanged, object: nil)
        }
    }
    @AppStorage("termsAccepted") var termsAccepted = false
    @AppStorage("trackingAccepted") var trackingAccepted = false {
        didSet {
            Tracker.setTrackingEnabled(trackingAccepted)
        }
    }
    @AppStorage("welcomeBlockIsRead") var welcomeBlockIsRead = false
    @AppStorage("notificationsEnabled") var notificationsEnabled = false

    @AppStorage("lastAttemptToPromotedPushNotifications") var lastAttemptToPromotedPushNotifications: TimeInterval = 0
    @AppStorage("lastPromotedPushNotificationsTime") var lastPromotedPushNotificationsTime: TimeInterval = 0

    @AppStorage("lastSuggestedToRateTime") var lastSuggestedToRateTime: TimeInterval = 0

    @AppStorage("unreadEvents") var unreadEvents = 0 {
        didSet {
            UNUserNotificationCenter.current().setBadgeCount(unreadEvents)
        }
    }
    @AppStorage("deviceId") var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

    @AppStorage("lastWhatsNewVersionDisplaied") var lastWhatsNewVersionDisplaied = ""

    @AppStorage("lastViewed_AI_SummaryTime") var lastViewed_AI_SummaryTime: TimeInterval = 0

    static var shared = SettingKeys()

    private init() {
        // Ensure authToken is aligned with selected profile
        Task {
            let selectedProfile = try! await UserProfile.selected()
            if SettingKeys.shared.authToken != (selectedProfile?.sessionId ?? "") {
                DispatchQueue.main.async {
                    SettingKeys.shared.authToken = selectedProfile?.sessionId ?? ""
                }
            }
        }
    }
    
    static func reset() {
        SettingKeys.shared.authToken = ""
        SettingKeys.shared.termsAccepted = false
        SettingKeys.shared.trackingAccepted = false
        SettingKeys.shared.notificationsEnabled = false
        SettingKeys.shared.lastPromotedPushNotificationsTime = 0
        SettingKeys.shared.lastSuggestedToRateTime = 0
        SettingKeys.shared.unreadEvents = 0
        SettingKeys.shared.lastWhatsNewVersionDisplaied = ""
        SettingKeys.shared.lastViewed_AI_SummaryTime = 0
    }
}

@propertyWrapper
struct Setting<T>: DynamicProperty {
    @StateObject private var keys = SettingKeys.shared
    private let key: ReferenceWritableKeyPath<SettingKeys, T>

    var wrappedValue: T {
        get {
            keys[keyPath: key]
        }

        nonmutating set {
            keys[keyPath: key] = newValue
        }
    }

    init(_ key: ReferenceWritableKeyPath<SettingKeys, T>) {
        self.key = key
    }
}
