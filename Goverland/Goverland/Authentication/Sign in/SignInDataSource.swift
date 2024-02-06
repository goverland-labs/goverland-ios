//
//  SignInDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine
import UIKit

class SignInDataSource: ObservableObject {
    @Published var loading = false
    private var cancellables = Set<AnyCancellable>()

    func guestAuth() {
        loading = true
        APIService.guestAuth(guestId: SettingKeys.shared.guestDeviceId,
                             deviceName: UIDevice.current.name,
                             defaultErrorDisplay: true)
            .sink { [weak self] _ in
                self?.loading = false
            } receiveValue: { response, headers in
                Task {
                    let profile = try! await UserProfile.upsert(profile: response.profile,
                                                                deviceId: SettingKeys.shared.guestDeviceId,
                                                                sessionId: response.sessionId, 
                                                                wcSessionMeta: nil,
                                                                cbAccount: nil)
                    try! await profile.select()
                }
                ProfileDataSource.shared.profile = response.profile
                logInfo("[App] Auth Token: \(response.sessionId); Profile: Guest")
            }
            .store(in: &cancellables)
    }
}
