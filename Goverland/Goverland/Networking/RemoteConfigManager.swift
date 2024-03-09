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
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] (status, error) in
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
              let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            logInfo("[FIREBASE] Remote config does not set min_app_supported_version")
            return
        }
        
        let currentVersion = Version(currentAppVersion)
        if let serverVersion = Version(serverAppVersion) {
            //print("[FIREBASE] Current App Version: \(currentVersion), Server App Version: \(serverVersion)")
            DispatchQueue.main.async {
                if currentVersion! < serverVersion {
                    self.isUpdateNeeded = true
                }
            }
        } else {
            print("NIL SERVER VALUE")
        }
    }
    
    private func checkForServerMaintenance() {
        let maintenance = remoteConfig.configValue(forKey: "server_maintenance_in_progress").boolValue
        DispatchQueue.main.async {
            self.isServerMaintenance = maintenance
        }
    }
}
