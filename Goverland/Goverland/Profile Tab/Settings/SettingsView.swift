//
//  SettingsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftDate

struct SettingsView: View {
    @Setting(\.authToken) private var authToken
    @StateObject private var dataSource = ProfileDataSource.shared
    @State private var isSignOutPopoverPresented = false
    @State private var isDeleteProfilePopoverPresented = false

    var body: some View {
        List {
            Section("Goverland") {
                NavigationLink("Notifications", value: ProfileScreen.pushNofitications)
            }

            if let profile = dataSource.profile, !authToken.isEmpty {
                Section("Devices") {
                    ForEach(profile.sessions) { s in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(s.deviceName)
                                    .font(.bodyRegular)
                                    .foregroundStyle(Color.textWhite)

                                if s.lastActivity + 10.minutes > .now {
                                    Text("Online")
                                        .font(.footnoteRegular)
                                        .foregroundStyle(Color.textWhite60)
                                } else {
                                    let activity = s.lastActivity.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
                                    Text("Last activity \(activity)")
                                        .font(.footnoteRegular)
                                        .foregroundStyle(Color.textWhite60)
                                }
                            }
                            Spacer()
                        }
                        .swipeActions {
                            Button {
                                ProfileDataSource.shared.signOut(sessionId: s.id.uuidString)
                                Tracker.track(.signOutDevice)
                            } label: {
                                Text("Sign out")
                                    .font(.bodyRegular)
                            }
                            .tint(.red)
                        }
                    }
                }
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
                    Button("Sign out") {
                        Haptic.medium()
                        isSignOutPopoverPresented.toggle()
                    }
                    .tint(Color.textWhite)
                }
            }

            Section(header: Text("Contact Us")) {
                XSettingsView()
                DiscordSettingsView()
                MailSettingView()
            }
            .ignoresSafeArea(edges: .horizontal)

            if !authToken.isEmpty {
                Section {
                    Button("Delete profile") {
                        Haptic.heavy()
                        isDeleteProfilePopoverPresented.toggle()
                    }
                    .tint(Color.textWhite)
                } header: {
                    Text("Dangerous area")
                } footer: {
                    Text("This profile will no longer be available. All your saved data will be permanently deleted.")
                        .font(.footnoteRegular)
                        .foregroundStyle(Color.textWhite40)
                }
            }
        }
        .sheet(isPresented: $isSignOutPopoverPresented) {
            SignOutPopoverView()
                .presentationDetents([.height(128)])
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
