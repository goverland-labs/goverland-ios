//
//  ProfileDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class ProfileDataSource: ObservableObject {
    @Published var profile: Profile?

    static let shared = ProfileDataSource()
    static let profileKey = "xyz.goverland.Profile"

    private init() {
        // try to get Profile from cache
        if let encodedProfile = UserDefaults.standard.data(forKey: Self.profileKey),
           let profile = try? JSONDecoder().decode(Profile.self, from: encodedProfile) {
            self.profile = profile
        }
    }

    // TODO: fetch profile by endpoint

    func cache(profile: Profile) {
        let encodedProfile = try! JSONEncoder().encode(profile)
        UserDefaults.standard.set(encodedProfile, forKey: Self.profileKey)
    }

    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Self.profileKey)
    }
}
