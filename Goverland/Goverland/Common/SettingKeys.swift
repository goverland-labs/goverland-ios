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
    @AppStorage("trackingAccepted") var trackingAccepted = false
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    @AppStorage("authToken") var authToken = ""

    static var shared = SettingKeys()
    
    static func reset() {
        SettingKeys.shared.onboardingFinished = false
        SettingKeys.shared.termsAccepted = false
        SettingKeys.shared.trackingAccepted = false
        SettingKeys.shared.notificationsEnabled = false
        SettingKeys.shared.authToken = ""
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
