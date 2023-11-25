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
    @AppStorage("termsAccepted") var termsAccepted = false
    @AppStorage("trackingAccepted") var trackingAccepted = false {
        didSet {
            Tracker.setTrackingEnabled(trackingAccepted)
        }
    }

    @AppStorage("authToken") var authToken = ""

    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    @AppStorage("lastPromotedPushNotificationsTime") var lastPromotedPushNotificationsTime: TimeInterval = 0

    @AppStorage("unreadEvents") var unreadEvents = 0 {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = unreadEvents
        }
    }

    static var shared = SettingKeys()

    private init() {}
    
    static func reset() {
        SettingKeys.shared.termsAccepted = false
        SettingKeys.shared.trackingAccepted = false

        SettingKeys.shared.authToken = ""
        WC_Manager.shared.sessionMeta = nil
        Profile.clearCache()

        SettingKeys.shared.notificationsEnabled = false
        SettingKeys.shared.lastPromotedPushNotificationsTime = 0
        SettingKeys.shared.unreadEvents = 0
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
