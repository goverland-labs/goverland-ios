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
    @Query private var profile: [UserProfile]
    @State private var accepted = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            #if STAGE
            Section(header: Text("Debug")) {
                Button("RESET") {
                    SettingKeys.reset()
                    try! modelContext.delete(model: UserProfile.self)
                    try! modelContext.save()
                    fatalError("Reset the app")
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

            if let id = profile.first(where: { $0.selected })?.deviceId {
                Section(header: Text("Support Token Id")) {
                    LabeledContent(id) {
                        Button {
                            UIPasteboard.general.string = id
                            showToast("Copied")
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .foregroundColor(.primaryDim)
                    }
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
