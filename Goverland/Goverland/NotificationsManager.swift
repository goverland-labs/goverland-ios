//
//  NotificationsManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.07.23.
//

import SwiftUI

class NotificationsManager {
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
}
