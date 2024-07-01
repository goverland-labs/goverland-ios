//
//  InboxNotificationsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.07.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class InboxNotificationsDataSource: ObservableObject, Refreshable {
    @Published var notificationsSettings: InboxNotificationSettings?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    static let shared = InboxNotificationsDataSource()

    private init() {}

    func refresh() {
        clear()
        loadSettings()
    }

    func clear() {
        notificationsSettings = nil
        isLoading = false
        cancellables = Set<AnyCancellable>()
    }

    private func loadSettings() {
        isLoading = true
        APIService.inboxNotificationSettings()
            .retry(3)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    logInfo("[INBOX SETTINGS] Finished to receive value")
                case .failure(_):
                    logInfo("[INBOX SETTINGS] Failed to receive value")
                }
            } receiveValue: { [weak self] settings, headers in
                logInfo("[INBOX SETTINGS] Received value: \(settings)")
                self?.notificationsSettings = settings
            }
            .store(in: &cancellables)
    }

    func updateSettings(settings: InboxNotificationSettings) {
        let oldSettings = notificationsSettings
        notificationsSettings = settings
        APIService.updateInboxNotificationSettings(settings: settings)
            .retry(3)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_):
                    logInfo("[INBOX SETTINGS] Failed to update")
                    self?.notificationsSettings = oldSettings
                }
            } receiveValue: { _, _ in
                logInfo("[INBOX SETTINGS] Successfully updated")
                Tracker.track(.settingsInboxSetCustomNtf)
            }
            .store(in: &cancellables)
    }
}
