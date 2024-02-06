//
//  ProfileDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

enum ProfileFilter: Int, FilterOptions {
    case activity = 0
    case achievements

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .achievements:
            return "Achievements"
        }
    }
}

class ProfileDataSource: ObservableObject, Refreshable {
    @Published var profile: Profile?
    @Published var failedToLoadInitialData = false
    @Published var filter: ProfileFilter = .activity

    private var cancellables = Set<AnyCancellable>()

    static let shared = ProfileDataSource()

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidToggle(_:)), name: .subscriptionDidToggle, object: nil)
    }

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

    func signOut(sessionId: String) {
        let signOutSelectedProfile = sessionId.lowercased() == SettingKeys.shared.authToken.lowercased()
        APIService.signOut(sessionId: sessionId)
            .sink { _ in
                // Do nothing. Error will be displayed if any.
            } receiveValue: { [weak self] _, _ in
                if signOutSelectedProfile {
                    Task {
                        try! await UserProfile.signOutSelected(logErrorIfNotFound: true)
                    }
                } else {
                    self?.refresh()
                }
            }
            .store(in: &cancellables)
    }

    func deleteProfile() {
        APIService.deleteProfile()
            .sink { _ in
                // Do nothing. Error will be displayed if any.
            } receiveValue: { _, _ in
                Task {
                    try! await UserProfile.signOutSelected(logErrorIfNotFound: true)
                    DispatchQueue.main.async {
                        showToast("Profile deleted.")
                    }
                }
            }
            .store(in: &cancellables)
    }

    @objc func subscriptionDidToggle(_ notification: Notification) {
        refresh()
    }
}
