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
import Version

class RemoteConfigManager: ObservableObject {
    static let shared = RemoteConfigManager()
    
    @Published private(set) var isUpdateNeeded: Bool = false
    @Published private(set) var isServerMaintenance: Bool = false
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private init() {}
    
    func fetchFirebaseRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            guard let self = self else { return }

            logInfo("[REMOTE CONFIG] Fetched remote Config. Status: \(status)")

            if status == .success {
                self.remoteConfig.activate { _, _ in
                    self.checkForUpdate()
                    self.checkForServerMaintenance()
                }
            } else {
                logInfo("[REMOTE CONFIG] Error fetching Remote Config: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func checkForUpdate() {
        guard let _minAppVersion = remoteConfig.configValue(forKey: "min_app_supported_version").stringValue,
              let minAppVersion = Version(_minAppVersion) else {
            logInfo("[REMOTE CONFIG] Remote config missing or incorrect min_app_supported_version")
            return
        }
        
        guard let _currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let currentAppVersion = Version(_currentAppVersion) else {
            logError(GError.appInconsistency(reason: "Wrong CFBundleShortVersionString"))
            return
        }

        logInfo("[REMOTE CONFIG] Min App Version: \(minAppVersion); Update is needed: \(currentAppVersion < minAppVersion)")
        DispatchQueue.main.async {
            self.isUpdateNeeded = currentAppVersion < minAppVersion
        }
    }
    
    private func checkForServerMaintenance() {
        let maintenance = remoteConfig.configValue(forKey: "server_maintenance_in_progress").boolValue
        logInfo("[REMOTE CONFIG] Server on maintenance: \(maintenance)")
        DispatchQueue.main.async {
            self.isServerMaintenance = maintenance
        }
    }
}
