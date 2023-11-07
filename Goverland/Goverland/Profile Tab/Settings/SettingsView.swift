//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                NavigationLink("Notifications", value: ProfileScreen.pushNofitications)
            }

            Section(header: Text("Contact Us")) {
                TwitterSettingsView()
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .onAppear() { Tracker.track(.screenSettings) }
    }
}
