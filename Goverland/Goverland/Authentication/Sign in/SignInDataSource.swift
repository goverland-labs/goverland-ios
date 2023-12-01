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
                        try! await UserProfile.update(with: response.profile, sessionId: response.sessionId)
                        try! await profile.select()
                    }
                    logInfo("[App] Auth Token: \(response.sessionId)")
                }
                .store(in: &cancellables)
        }
    }
}
