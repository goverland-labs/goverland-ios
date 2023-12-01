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
    @AppStorage("authToken") var authToken = ""

    static var shared = SettingKeys()

    private init() {}
    
    static func reset() {
        SettingKeys.shared.authToken = ""
        WC_Manager.shared.sessionMeta = nil
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
