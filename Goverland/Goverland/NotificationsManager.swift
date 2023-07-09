//
//  NotificationsManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 09.07.23.
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

    func verifyGlobalNotificationSettingsEnabled(completion: @escaping (_ enabled: Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    func enableNotifications() {
        // verify that token is there and user enabled notifications
        guard let token = Messaging.messaging().fcmToken, SettingKeys.shared.notificationsEnabled else { return }
        
        APIService.enableNotifications(token)
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_): break // Token will be requested on every app start, so no need to retry for now
                }
            } receiveValue: { response, headers in }
            .store(in: &cancellables)
    }

    func disableNotifications(completion: @escaping (Bool) -> Void) {
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
