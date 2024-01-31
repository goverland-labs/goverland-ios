//
//  AdvancedSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct AdvancedSettingView: View {
    @Query private var profiles: [UserProfile]
    @State private var accepted = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            #if STAGE
            Section(header: Text("Debug")) {
                Button("RESET") {
                    SettingKeys.reset()
                    WC_Manager.shared.sessionMeta = nil
                    CoinbaseWalletManager.shared.account = nil
                    try! modelContext.delete(model: UserProfile.self)
                    try! modelContext.save()
                    fatalError("Reset the app")
                }
                .tint(.dangerText)

                Button("CRASH") {
                    fatalError("Crash the App")
                }
                .tint(.dangerText)

                Button("LOG ERROR") {
                    logError(GError.appInconsistency(reason: "Debug test error logging"))
                }
                .tint(.dangerText)

                Button("Show test notification in 3 sec") {
                    showLocalNotification(title: "Test local notification",
                                          body: "Local notification body",
                                          delay: 3.0)
                }
            }
            #endif

            Section {
                Toggle(isOn: $accepted) {
                    Text("Allow app to track activity")
                }
            } header: {
                Text("Share anonymized data")
            } footer: {
                Text("To ensure the quality of our app, we collect anonymized app usage data and crash reports.")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite40)
            }

            if let id = profiles.first(where: { $0.selected })?.deviceId {
                Section {
                    LabeledContent(id) {
                        Button {
                            UIPasteboard.general.string = id
                            showToast("Copied")
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .foregroundColor(.primaryDim)
                    }
                } header: {
                    Text("Support id")
                } footer: {
                    Text("If you contact our support team regarding a technical issue, be ready to share this id.")
                        .font(.footnoteRegular)
                        .foregroundColor(.textWhite40)
                }
            }

            if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                Section(header: Text("Meta-info")) {
                    LabeledContent("Build number", value: buildNumber)
                }
            }
        }
        .onChange(of: accepted) { oldValue, newValue in
            if !newValue {
                Tracker.track(.settingsDisableTracking)
            }
            SettingKeys.shared.trackingAccepted = accepted
        }
        .onAppear() {
            accepted = SettingKeys.shared.trackingAccepted
            Tracker.track(.screenAdvancedSettings)
        }
    }
}
