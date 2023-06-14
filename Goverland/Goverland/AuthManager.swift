//
//  AuthManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.06.23.
//

import SwiftUI
import Combine

class AuthManager {
    private var cancellables = Set<AnyCancellable>()
    private var retryTimer: Timer?

    static var shared = AuthManager()

    private init() {}

    func updateToken() {
        retryTimer?.invalidate()
        retryTimer = nil

        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        APIService.authToken(deviceId: deviceId, defaultErrorDisplay: false)
            .retry(3)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.scheduleRetry()
                }
            } receiveValue: { response, headers in
                SettingKeys.shared.authToken = response.sessionId
            }
            .store(in: &cancellables)
    }

    private func scheduleRetry() {
        retryTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.updateToken()
        }
    }
}
