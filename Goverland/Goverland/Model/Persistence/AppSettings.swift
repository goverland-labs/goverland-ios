//
//  Schema.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

@Model
final class AppSettings {
    var termsAccepted: Bool
    private(set) var trackingAccepted: Bool
    var notificationsEnabled: Bool
    var lastPromotedPushNotificationsTime: TimeInterval
    private(set) var unreadEvents: Int

    init(termsAccepted: Bool = false,
         trackingAccepted: Bool = false,
         notificationsEnabled: Bool = false,
         lastPromotedPushNotificationsTime: TimeInterval = 0,
         unreadEvents: Int = 0) 
    {
        self.termsAccepted = termsAccepted
        self.trackingAccepted = trackingAccepted
        self.notificationsEnabled = notificationsEnabled
        self.lastPromotedPushNotificationsTime = lastPromotedPushNotificationsTime
        self.unreadEvents = unreadEvents
    }
}

extension AppSettings {
    func setTrackingAccepted(_ accepted: Bool) {
        self.trackingAccepted = accepted
        Tracker.setTrackingEnabled(accepted)
    }

    func setUnreadEvents(count: Int) {
        self.unreadEvents = count
        UNUserNotificationCenter.current().setBadgeCount(count)
    }

    @MainActor
    static var notificationsEnabled: Bool {
        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1
        if let appSettings = try? appContainer.mainContext.fetch(fetchDescriptor).first {
            return appSettings.notificationsEnabled
        } else {
            logInfo("[AppSettings] Failed to fetch AppSettings in notificationsEnabled")
            return false
        }
    }

    @MainActor
    static var unreadEvents: Int {
        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1
        if let appSettings = try? appContainer.mainContext.fetch(fetchDescriptor).first {
            return appSettings.unreadEvents
        } else {
            logInfo("[AppSettings] Failed to fetch AppSettings in unreadEvents")
            return 0
        }
    }

    @MainActor
    static func setUnreadEvents(_ count: Int) {
        var fetchDescriptor = FetchDescriptor<AppSettings>()
        fetchDescriptor.fetchLimit = 1
        if let appSettings = try? appContainer.mainContext.fetch(fetchDescriptor).first {
            appSettings.setUnreadEvents(count: count)
            try? appContainer.mainContext.save()
        } else {
            logInfo("[AppSettings] Failed to fetch AppSettings in setUnreadEvents")
        }
    }
}
