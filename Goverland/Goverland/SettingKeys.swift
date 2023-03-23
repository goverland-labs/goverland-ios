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

    static var shared = SettingKeys()
    
    static func reset() {
        SettingKeys().onboardingFinished = false
        SettingKeys().termsAccepted = false
        SettingKeys().trackingAccepted = false
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
