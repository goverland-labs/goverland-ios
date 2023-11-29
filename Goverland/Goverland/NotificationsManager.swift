//
//  NotificationsManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseMessaging


class NotificationsManager {
    private var cancellables = Set<AnyCancellable>()

    static let shared = NotificationsManager()

    private init() {}

    func setUpMessaging(delegate: MessagingDelegate & UNUserNotificationCenterDelegate) {
        logInfo("Setting up notifications handling")
        UNUserNotificationCenter.current().delegate = delegate
        Messaging.messaging().delegate = delegate
    }

    func requestUserPermissionAndRegister(completion: @escaping (_ granted: Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            if let error = error {
                logError(error)
            }
            completion(granted)
        }
    }

    func getNotificationsStatus(completion: @escaping (_ status: UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func enableNotifications() {
        // verify that token is there and user enabled notifications
        Task {
            guard let token = Messaging.messaging().fcmToken, await AppSettingsRead.notificationsEnabled else { return }
            logInfo("[App] Enabling push notifications")
            APIService.enableNotifications(token, defaultErrorDisplay: false)
                .retry(3)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_): break // Token will be requested on every app start, so no need to retry for now
                    }
                } receiveValue: { response, headers in }
                .store(in: &cancellables)
        }
    }

    func disableNotifications(completion: @escaping (Bool) -> Void) {
        logInfo("[App] Disabling push notifications")
        APIService.disableNotifications()
            .sink { _completion in
                switch _completion {
                case .finished: break
                case .failure(_): completion(false)
                }
            } receiveValue: { response, headers in
                completion(true)
            }
            .store(in: &cancellables)
    }
}
