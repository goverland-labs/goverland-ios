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
    @Query private var appSettings: [AppSettings]
    @State private var accepted = false

    var body: some View {
        List {
            #if STAGE
            Section(header: Text("Debug")) {
                Button("RESET") {
                    // TODO: store in Model
                    WC_Manager.shared.sessionMeta = nil

                    appSettings.first!.reset()
                }
                .accentColor(.dangerText)

                Button("CRASH") {
                    fatalError("Crash the App")
                }
                .accentColor(.dangerText)

                Button("LOG ERROR") {
                    logError(GError.appInconsistency(reason: "Debug test error logging"))
                }
                .accentColor(.dangerText)
            }
            #endif

            Section(header: Text("Share anonymized data")) {
                Toggle(isOn: $accepted) {
                    Text("Allow App to Track Activity")
                }
            }

            Section(header: Text("Auth token")) {
                LabeledContent(SettingKeys.shared.authToken) {
                    Button {
                        UIPasteboard.general.string = SettingKeys.shared.authToken
                        showToast("Copied")
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .foregroundColor(.primaryDim)
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
            appSettings.first!.setTrackingAccepted(newValue)
        }
        .onAppear() {
            accepted = appSettings.first!.trackingAccepted
            Tracker.track(.screenAdvancedSettings)
        }
    }
}
