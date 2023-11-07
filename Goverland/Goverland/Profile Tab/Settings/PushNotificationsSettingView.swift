//
//  PushNotificationsSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PushNotificationsSettingView: View {
    @State private var notificationsEnabled = SettingKeys.shared.notificationsEnabled
    @State private var showAlert = false
    @State private var skipTrackingOnce = false

    var body: some View {
        List {
            Toggle("Receive updates from DAOs", isOn: $notificationsEnabled)
        }
        .onChange(of: notificationsEnabled) { toggleEnabled in
            NotificationsManager.shared.getNotificationsStatus { status in
                switch status {
                case .notDetermined:
                    if toggleEnabled {
                        Tracker.track(.settingsEnableGlbNotifications)
                        NotificationsManager.shared.requestUserPermissionAndRegister { granted in
                            DispatchQueue.main.async {
                                SettingKeys.shared.notificationsEnabled = granted
                                notificationsEnabled = granted
                            }
                        }
                    } else {
                        // should not happen
                        logError(GError.appInconsistency(reason: "Enabled notifications toggle without determined permission."))
                    }

                case .denied:
                    if toggleEnabled {
                        // Notifications are disabled in app settings
                        notificationsEnabled = false
                        showAlert = true
                    } else {
                        logInfo("Auto-disabled notifications toggle")
                    }
                default:
                    if toggleEnabled {
                        if !skipTrackingOnce {
                            Tracker.track(.settingsEnableGlbNotifications)
                        } else {
                            skipTrackingOnce = false
                        }
                        SettingKeys.shared.notificationsEnabled = true
                        NotificationsManager.shared.enableNotifications()
                    } else {
                        Tracker.track(.settingsDisableGlbNotifications)
                        NotificationsManager.shared.disableNotifications { disabled in
                            guard disabled else {
                                // Error will be displayed automatically if there was a networking issue
                                skipTrackingOnce = true
                                notificationsEnabled = true
                                return
                            }
                            SettingKeys.shared.notificationsEnabled = false
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("To receive notifications, enable them in your device's settings."),
                primaryButton: .default(Text("Open Settings"), action: showAppSettings),
                secondaryButton: .cancel()
            )
        }
        .onAppear() { Tracker.track(.screenNotifications) }
    }

    private func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
}


