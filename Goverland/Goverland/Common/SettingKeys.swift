//
//  SettingKeys.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import Foundation
import SwiftUI

class SettingKeys: ObservableObject {
    @AppStorage("termsAccepted") var termsAccepted = false
    @AppStorage("onboardingFinished") var onboardingFinished = false
    @AppStorage("trackingAccepted") var trackingAccepted = false {
        didSet {
            Tracker.setTrackingEnabled(trackingAccepted)
        }
    }
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    @AppStorage("signInAsGuest") var signInAsGuest = false
    @AppStorage("authToken") var authToken = ""
    @AppStorage("unreadEvents") var unreadEvents = 0 {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = unreadEvents
        }
    }

    static var shared = SettingKeys()

    private init() {}
    
    static func reset() {
        SettingKeys.shared.onboardingFinished = false
        SettingKeys.shared.termsAccepted = false
        SettingKeys.shared.trackingAccepted = false
        SettingKeys.shared.notificationsEnabled = false
        SettingKeys.shared.authToken = ""
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
