//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Setting(\.authToken) private var authToken
    @State private var isDeleteProfilePopoverPresented = false

    var body: some View {
        List {
            Section(header: Text("Contact Us")) {
                XSettingsView()
                DiscordSettingsView()
                MailSettingView()
            }

            Section {
                NavigationLink("About", value: ProfileScreen.about)
                NavigationLink("Help us grow", value: ProfileScreen.helpUsGrow)
                NavigationLink("Partnership", value: ProfileScreen.partnership)
                NavigationLink("Advanced", value: ProfileScreen.advanced)
                LabeledContent("App version", value: Bundle.main.releaseVersionNumber!)
            }

            if !authToken.isEmpty {
                Section {
                    Button("Delete profile") {
                        isDeleteProfilePopoverPresented.toggle()
                    }
                    .tint(Color.textWhite)
                } header: {
                    Text("Dangerous area")
                } footer: {
                    Text("This profile will no longer be available. All your saved data will be permanently deleted.")
                        .font(.footnoteRegular)
                        .foregroundColor(.textWhite40)
                }
            }
        }
        .sheet(isPresented: $isDeleteProfilePopoverPresented) {
            DeleteProfilePopoverView()
                .presentationDetents([.height(320), .large])
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .onAppear() { Tracker.track(.screenSettings) }
    }
}
