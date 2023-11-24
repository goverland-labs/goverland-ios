//
//  ProfileDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class ProfileDataSource: ObservableObject, Refreshable {
    @Published var profile: Profile?
    @Published var failedToLoadInitialData = false

    private var cancellables = Set<AnyCancellable>()

    static let shared = ProfileDataSource()
    static let profileKey = "xyz.goverland.profile"

    private init() {
        // try to get Profile from cache
        if let encodedProfile = UserDefaults.standard.data(forKey: Self.profileKey),
           let profile = try? JSONDecoder().decode(Profile.self, from: encodedProfile) {
            self.profile = profile
        }
    }

    func refresh() {
        profile = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()

        loadProfile()
    }

    private func loadProfile() {
        APIService.profile()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] profile, _ in
                self?.profile = profile
                self?.cache(profile: profile)
            }
            .store(in: &cancellables)
    }

    func cache(profile: Profile) {
        let encodedProfile = try! JSONEncoder().encode(profile)
        UserDefaults.standard.set(encodedProfile, forKey: Self.profileKey)
    }

    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Self.profileKey)
    }
}
