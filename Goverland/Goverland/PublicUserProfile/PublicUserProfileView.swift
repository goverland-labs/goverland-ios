//
//  PublicUserProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

enum PublicUserProfileScreen: Hashable {
    case votedInDaos
    case votes
    case vote(Proposal)
}

struct PublicUserProfileView: View {
    @StateObject private var dataSource: PublicUserProfileDataSource
    @State private var path = [PublicUserProfileScreen]()
    @Environment(\.dismiss) private var dismiss
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(profileId: String) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileDataSource(profileId: profileId))
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if dataSource.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load public user profile")
                } else if dataSource.profile == nil {
                    ShimmerProfileHeaderView()
                    Spacer()
                } else if let profile = dataSource.profile {
                    ProfileHeaderView(user: profile, publicUser: true)

                    FilterButtonsView<PublicUserProfileFilter>(filter: $dataSource.filter)

                    switch dataSource.filter {
                    case .activity:
                        PublicUserProfileActivityView(user: profile, path: $path)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarTitle("User profile")
            }
            .onAppear {
                Tracker.track(.screenPublicProfile)
                if dataSource.profile == nil {
                    dataSource.refresh()
                }
            }
            .navigationDestination(for: PublicUserProfileScreen.self) { publicUserProfileScreen in
                switch publicUserProfileScreen {
                case .votedInDaos:
                    PublicUserProfileDaosListView(profileId: dataSource.profileId)
                        .environmentObject(activeSheetManager)
                case .votes:
                    PublicUserProfileVotesListView(user: dataSource.profile!,
                                                   path: $path)
                        .environmentObject(activeSheetManager)
                case .vote(let proposal):
                    SnapshotProposalView(proposal: proposal)
                        .environmentObject(activeSheetManager)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
                if activeSheetManager.activeSheet == nil {
                    activeSheetManager.activeSheet = .signIn
                }
            }
            .onChange(of: lastAttemptToPromotedPushNotifications) { _, _ in
                showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
            }
        }
    }
}
