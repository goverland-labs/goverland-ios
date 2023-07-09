//
//  NotificationsManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.07.23.
//

import SwiftUI
import FirebaseMessaging


class NotificationsManager {
    static func setUpMessaging(delegate: MessagingDelegate & UNUserNotificationCenterDelegate) {
        logInfo("Setting up notifications handling")
        UNUserNotificationCenter.current().delegate = delegate
        Messaging.messaging().delegate = delegate
    }

    static func requestUserPermissionAndRegister(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            if let error = error {
                logError(error)
            }
            completion()
        }
    }

    static func verifyGlobalNotificationSettingsEnabled(completion: @escaping (_ enabled: Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}
