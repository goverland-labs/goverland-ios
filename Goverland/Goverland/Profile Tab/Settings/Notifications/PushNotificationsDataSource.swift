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
    @Published var notificationsSettings: NotificationsSettings?
    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        clear()
        loadSettings()
    }

    private func clear() {
        notificationsSettings = nil
        cancellables = Set<AnyCancellable>()
    }

    private func loadSettings() {
        APIService.notificationsSettings()
            .retry(3)
            .sink { _ in
                // do nothing
            } receiveValue: { [weak self] settings, headers in
                self?.notificationsSettings = settings
            }
            .store(in: &cancellables)
    }

    func updateSettings(settings: NotificationsSettings, completion: @escaping (Bool) -> Void) {
        logInfo("[App] Update notification settings with \(settings)")
        APIService.updateNotificationsSettings(settings: settings)
            .retry(3)
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
