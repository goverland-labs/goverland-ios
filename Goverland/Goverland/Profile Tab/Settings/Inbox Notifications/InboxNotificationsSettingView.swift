//
//  InboxNotificationsSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.07.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct InboxNotificationsSettingView: View {
    @ObservedObject var dataSource = InboxNotificationsDataSource.shared

    var body: some View {
        Group {
            if dataSource.isLoading {
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if let notificationSettings = dataSource.notificationsSettings {
                List {
                    Section {
                        Toggle("Archive proposal notifications after vote", isOn: Binding(
                            get: {
                                notificationSettings.archiveProposalAfterVote
                            }, set: { newValue in
                                let settings = notificationSettings.with(archiveProposalAfterVote: newValue)
                                dataSource.updateSettings(settings: settings)
                            }))
                        .tint(.green)

                    // TODO: atoarchive after

                    } header: {
                        Text("Archive")
                    } footer: {
                        Text("You can find archived notifications in your inbox")
                            .font(.footnoteRegular)
                            .foregroundStyle(Color.textWhite40)
                    }
                }
            } else {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the settings")
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

