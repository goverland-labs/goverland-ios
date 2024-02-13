//
//  AppUpdateManager.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-12.
//  Copyright © Goverland Inc. All rights reserved.
//


import Foundation
import Firebase
import FirebaseRemoteConfig

class AppUpdateManager: ObservableObject {
    static let shared = AppUpdateManager()
    
    @Published private(set) var isUpdateNeeded: Bool = false
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        configureRemoteConfig()
        fetchFirebaseRemoteConfig()
    }
    
    private func configureRemoteConfig() {
        // by defaul Google Firebase cashing fetch
        // forcing fetch every time
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    private func fetchFirebaseRemoteConfig() {
        remoteConfig.fetch { [weak self] (status, error) in
            guard let self = self else { return }
            
            if status == .success {
                self.remoteConfig.activate { _, _ in
                    self.checkForUpdate()
                }
            } else {
                logInfo("[FIREBASE] Error fetching Remote Config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func checkForUpdate() {
        guard let serverAppVersion = remoteConfig.configValue(forKey: "minAppSupportedVersion").stringValue,
              let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let currentAppVersionD = Double(currentAppVersion),
              let serverAppVersionD = Double(serverAppVersion) else {
            logInfo("[FIREBASE] Remote config does not set minAppSupportedVersion")
            return
        }
        
        DispatchQueue.main.async {
            if currentAppVersionD < serverAppVersionD {
                self.isUpdateNeeded = true
            }
        }
    }
}
