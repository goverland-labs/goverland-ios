//
//  AdvancedSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct AdvancedSettingView: View {
    @State private var accepted = false

    var body: some View {
        List {
            #if STAGE
            Section(header: Text("Debug")) {
                Button("RESET") {
                    SettingKeys.reset()
                    fatalError("Crash with Reset button")
                }
                .accentColor(.dangerText)

                Button("LOG ERROR") {
                    logError(GError.appInconsistency(reason: "Debug test error logging"))
                }
                .accentColor(.textWhite60)
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
        .onChange(of: accepted) { accepted in
            if !accepted {
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
