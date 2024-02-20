//
//  RemoteConfigManager.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-14.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Firebase
import FirebaseRemoteConfig

class RemoteConfigManager: ObservableObject {
    static let shared = RemoteConfigManager()
    
    @Published private(set) var isUpdateNeeded: Bool = false
    @Published private(set) var isServerMaintenance: Bool = false
    
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
                    self.checkForServerMaintenance()
                }
            } else {
                logInfo("[FIREBASE] Error fetching Remote Config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func checkForUpdate() {
        guard let serverAppVersion = remoteConfig.configValue(forKey: "min_app_supported_version").stringValue,
              let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let currentAppVersionD = Double(currentAppVersion),
              let serverAppVersionD = Double(serverAppVersion) else {
            logInfo("[FIREBASE] Remote config does not set min_app_supported_version")
            return
        }
        DispatchQueue.main.async {
            if currentAppVersionD < serverAppVersionD {
                self.isUpdateNeeded = true
            }
        }
    }
    
    private func checkForServerMaintenance() {
        let maintenance = remoteConfig.configValue(forKey: "server_maintenance_in_progress").boolValue
        DispatchQueue.main.async {
            print("--------------------\(maintenance)")
            self.isServerMaintenance = maintenance
        }
    }
}
