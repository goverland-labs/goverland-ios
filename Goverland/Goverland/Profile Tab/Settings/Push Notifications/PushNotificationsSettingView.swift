//
//  PushNotificationsSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PushNotificationsSettingView: View {
    @ObservedObject var dataSource = PushNotificationsDataSource.shared
    @State private var notificationsEnabled = SettingKeys.shared.notificationsEnabled
    @State private var showAlert = false
    @State private var skipTrackingOnce = false

    var body: some View {
        List {
            Section {
                Toggle("Receive notifications", isOn: $notificationsEnabled)
                    .tint(.green)
            } header: {
                Text("Push notifications")
            } footer: {
                if !notificationsEnabled {
                    Text("Set up customizable notifications for DAO proposals and delegates' actions")
                        .font(.footnoteRegular)
                        .foregroundStyle(Color.textWhite40)
                }
            }

            if let notificationsSettings = dataSource.notificationsSettings, notificationsEnabled {
                Section("Proposals") {
                    Toggle("New proposal created", isOn: Binding(
                        get: {
                            notificationsSettings.daoSettings.newProposalCreated
                        }, set: { newValue in
                            let settings = PushNotificationSettings(
                                daoSettings: notificationsSettings.daoSettings.with(newProposalCreated: newValue)
                            )
                            dataSource.updateSettings(settings: settings)
                        }))
                    .tint(.green)
                    Toggle("Quorum reached", isOn: Binding(
                        get: {
                            notificationsSettings.daoSettings.quorumReached
                        }, set: { newValue in
                            let settings = PushNotificationSettings(
                                daoSettings: notificationsSettings.daoSettings.with(quorumReached: newValue)
                            )
                            dataSource.updateSettings(settings: settings)
                        }))
                    .tint(.green)
                    Toggle("Vote finishes soon", isOn: Binding(
                        get: {
                            notificationsSettings.daoSettings.voteFinishesSoon
                        }, set: { newValue in
                            let settings = PushNotificationSettings(
                                daoSettings: notificationsSettings.daoSettings.with(voteFinishesSoon: newValue)
                            )
                            dataSource.updateSettings(settings: settings)
                        }))
                    .tint(.green)
                    Toggle("Vote finished", isOn: Binding(
                        get: {
                            notificationsSettings.daoSettings.voteFinished
                        }, set: { newValue in
                            let settings = PushNotificationSettings(
                                daoSettings: notificationsSettings.daoSettings.with(voteFinished: newValue)
                            )
                            dataSource.updateSettings(settings: settings)
                        }))
                    .tint(.green)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Push Notifications")
        .onChange(of: notificationsEnabled) { _, toggleEnabled in
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
                        logError(GError.appInconsistency(reason: "Enabled notifications toggle without determined permission"))
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
                            // on purpose
                            SettingKeys.shared.notificationsEnabled = true
                            // optimistic enabling
                            NotificationsManager.shared.enableNotificationsIfNeeded()
                            // update notifications settings
                            dataSource.refresh()
                        } else {
                            skipTrackingOnce = false
                        }
                    } else {
                        Tracker.track(.settingsDisableGlbNotifications)
                        NotificationsManager.shared.disableNotifications { disabled in
                            guard disabled else {
                                // Error will be displayed automatically if there was a networking issue
                                skipTrackingOnce = true
                                notificationsEnabled = true
                                return
                            }
                            // on purpose
                            SettingKeys.shared.notificationsEnabled = false
                            // update notifications settings
                            dataSource.clear()
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("To receive notifications, enable them in your device's settings"),
                primaryButton: .default(Text("Open Settings"), action: Utils.openAppSettings),
                secondaryButton: .cancel()
            )
        }
        .onAppear() {
            Tracker.track(.screenNotifications)
            if notificationsEnabled {
                dataSource.refresh()
            }
        }
    }    
}


