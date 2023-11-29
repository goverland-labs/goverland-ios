//
//  Schema.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData

@Model
final class AppSettings {
    var termsAccepted: Bool
    private(set) var trackingAccepted: Bool
    var notificationsEnabled: Bool
    var lastPromotedPushNotificationsTime: TimeInterval

    init(termsAccepted: Bool = false,
         trackingAccepted: Bool = false,
         notificationsEnabled: Bool = false,
         lastPromotedPushNotificationsTime: TimeInterval = 0) {
        self.termsAccepted = termsAccepted
        self.trackingAccepted = trackingAccepted
        self.notificationsEnabled = notificationsEnabled
        self.lastPromotedPushNotificationsTime = lastPromotedPushNotificationsTime
    }
}

extension AppSettings {
    func setTrackingAccepted(_ accepted: Bool) {
        self.trackingAccepted = accepted
        Tracker.setTrackingEnabled(accepted)
    }

    func reset() {
        termsAccepted = false
        setTrackingAccepted(false)
        lastPromotedPushNotificationsTime = 0
    }
}

@MainActor
enum AppSettingsRead {
    static var notificationsEnabled: Bool {
        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1
        if let appSettings = try? appContainer.mainContext.fetch(fetchDescriptor).first {
            return appSettings.notificationsEnabled
        } else {
            logInfo("[AppSettings] Failed to fetch AppSettings in AppSettingsRead")
            return false
        }
    }
}
