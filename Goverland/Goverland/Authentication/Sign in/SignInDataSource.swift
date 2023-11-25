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
        APIService.guestAuth(guestId: UUID().uuidString, defaultErrorDisplay: true)
            .sink { [weak self] _ in
                self?.loading = false
            } receiveValue: { response, headers in
                SettingKeys.shared.authToken = response.sessionId
                logInfo("Auth token: \(response.sessionId)")
            }
            .store(in: &cancellables)
    }
}
