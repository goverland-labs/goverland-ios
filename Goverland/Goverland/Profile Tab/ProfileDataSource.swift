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

    private init() {}

    func refresh() {
        clear()
        loadProfile()
    }

    private func clear() {
        profile = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
    }

    private func loadProfile() {
        APIService.profile()
            .sink { [weak self] respCompletion in
                switch respCompletion {
                case .finished: break
                case .failure(_): 
                    self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] profile, _ in
                self?.profile = profile
                Task {
                    try! await UserProfile.softUpdateExisting(profile: profile)
                }
            }
            .store(in: &cancellables)
    }
}
