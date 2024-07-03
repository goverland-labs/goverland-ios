//
//  PushNotificationsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class PushNotificationsDataSource: ObservableObject, Refreshable {
    @Published var notificationsSettings: PushNotificationSettings?
    private var cancellables = Set<AnyCancellable>()

    static let shared = PushNotificationsDataSource()

    private init() {}

    func refresh() {
        clear()
        loadSettings()
    }

    func clear() {
        notificationsSettings = nil
        cancellables = Set<AnyCancellable>()
    }

    private func loadSettings() {
        APIService.pushNotificationSettingsDetails()
            .retry(3)
            .sink { completion in
                switch completion {
                case .finished:
                    logInfo("[PUSH SETTINGS] Finished to receive value")
                case .failure(_):
                    logInfo("[PUSH SETTINGS] Failed to receive value")
                }
            } receiveValue: { [weak self] settings, headers in
                logInfo("[PUSH SETTINGS] Received value: \(settings)")
                self?.notificationsSettings = settings
            }
            .store(in: &cancellables)
    }

    func updateSettings(settings: PushNotificationSettings) {
        let oldSettings = notificationsSettings
        notificationsSettings = settings
        APIService.updatePushNotificationSettings(settings: settings)
            .retry(3)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): 
                    logInfo("[PUSH SETTINGS] Failed to update")
                    self?.notificationsSettings = oldSettings
                }
            } receiveValue: { _, _ in
                logInfo("[PUSH SETTINGS] Successfully updated")
                Tracker.track(.settingsSetCustomNtfDetails)
            }
            .store(in: &cancellables)
    }
}
