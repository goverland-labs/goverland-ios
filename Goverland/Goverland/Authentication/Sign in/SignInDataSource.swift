//
//  SignInDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class SignInDataSource: ObservableObject {
    @Published var loading = false
    private var cancellables = Set<AnyCancellable>()

    func guestAuth() {
        loading = true
        Task {
            let profile = try! await UserProfile.getOrCreateGuestProfile()
            APIService.guestAuth(guestId: profile.deviceId, defaultErrorDisplay: true)
                .sink { [weak self] _ in
                    self?.loading = false
                } receiveValue: { response, headers in
                    Task {
                        try! await profile.select()
                        try! await UserProfile.updateSessionIdForSelectedProfile(with: response.sessionId)
                    }
                    logInfo("[App] Auth Token: \(response.sessionId)")
                }
                .store(in: &cancellables)
        }
    }
}
