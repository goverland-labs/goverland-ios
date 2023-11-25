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
                // TODO: use a proper profile object
                let profile = Profile.testRegular
                SettingKeys.shared.storeAuthTokenAndCacheProfile(authToken: response.sessionId, profile: profile)
                logInfo("Auth token: \(response.sessionId); Profile: \(profile)")
            }
            .store(in: &cancellables)
    }
}
