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
        loadProfile() { _ in }
    }

    func refresh(completion: @escaping (Profile?) -> Void) {
        clear()
        loadProfile(completion: completion)
    }

    private func clear() {
        profile = nil
        failedToLoadInitialData = false
        cancellables = Set<AnyCancellable>()
    }

    private func loadProfile(completion: @escaping (Profile?) -> Void) {
        APIService.profile()
            .sink { [weak self] respCompletion in
                switch respCompletion {
                case .finished: break
                case .failure(_): 
                    self?.failedToLoadInitialData = true
                    completion(nil)
                }
            } receiveValue: { [weak self] profile, _ in
                self?.profile = profile
                completion(profile)
            }
            .store(in: &cancellables)
    }
}
