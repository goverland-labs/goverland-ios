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

    @State private var showTestMarkdown = false

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

                NavigationLink("Show Test Markdown in stack") {
                    TestMarkdownView()
                }

                Button("Show Test Markdown in popover") {
                    showTestMarkdown = true
                }

                Button("Show short info alert") {
                    showInfoAlert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et [dolore magna aliqua](https://www.openai.com).")
                }

                Button("Show almost long info alert") {
                    showInfoAlert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem.")
                }

                Button("Show long info alert") {
                    showInfoAlert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.")
                }
            }
            #endif

            Section {
                Toggle(isOn: $accepted) {
                    Text("Allow app to track activity")
                }
                .tint(.green)
            } header: {
                Text("Share anonymized data")
            } footer: {
                Text("To ensure the quality of our app, we collect anonymized app usage data and crash reports.")
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite40)
            }

            if let id = profiles.first(where: { $0.selected })?.deviceId.prefix(8) {
                Section {
                    LabeledContent(id) {
                        Button {
                            UIPasteboard.general.string = String(id)
                            showToast("Copied")
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .foregroundStyle(Color.primaryDim)
                    }
                } header: {
                    Text("Support id")
                } footer: {
                    Text("If you contact our support team regarding a technical issue, be ready to share this id.")
                        .font(.footnoteRegular)
                        .foregroundStyle(Color.textWhite40)
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
        .sheet(isPresented: $showTestMarkdown) {
            TestMarkdownView()
        }
    }
}
