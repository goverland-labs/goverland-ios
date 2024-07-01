//
//  InboxNotificationsSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.07.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct InboxNotificationsSettingView: View {
    @ObservedObject var dataSource = InboxNotificationsDataSource.shared
    @Query private var profiles: [UserProfile]

    var selectedProfileIsGuest: Bool {
        profiles.first(where: { $0.selected })?.address.isEmpty ?? false
    }

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the settings")
            } else if let notificationSettings = dataSource.notificationsSettings {
                List {
                    Section {
                        if !selectedProfileIsGuest {
                            Toggle("Archive proposals after vote", isOn: Binding(
                                get: {
                                    notificationSettings.archiveProposalAfterVote
                                }, set: { newValue in
                                    let settings = notificationSettings.with(archiveProposalAfterVote: newValue)
                                    dataSource.updateSettings(settings: settings)
                                }))
                            .tint(.green)
                        }

                        Picker("Auto archive finished proposals after", selection: Binding(
                            get: {
                                notificationSettings.autoarchiveAfter
                            },
                            set: { newValue in
                                let settings = notificationSettings.with(autoarchiveAfter: newValue)
                                dataSource.updateSettings(settings: settings)
                            }
                        )) {
                            ForEach(InboxNotificationSettings.Timeframe.allCases, id: \.self) { option in
                                Text(option.localizedDescription).tag(option)
                            }
                        }
                    } header: {
                        Text("Archive")
                    } footer: {
                        Text("You can find archived notifications in your inbox")
                            .font(.footnoteRegular)
                            .foregroundStyle(Color.textWhite40)
                    }
                }
            } else { // is loading
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Inbox Notifications")
        .onAppear() {
            Tracker.track(.screenInboxNotifications)
            if dataSource.notificationsSettings == nil {
                dataSource.refresh()
            }
        }
    }
}
