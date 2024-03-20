//
//  ProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

enum ProfileScreen: Hashable {
    case settings
    case followedDaos
    case votes
    case vote(Proposal)

    // Settings
    case pushNofitications
    case about
    case helpUsGrow
    case partnership
    case advanced
}

struct ProfileView: View {
    @Binding var path: [ProfileScreen]
    @Setting(\.authToken) private var authToken

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                if authToken.isEmpty {
                    SignInView(source: .profile)
                } else {
                    _ProfileView(path: $path)
                }
            }
            .id(authToken) // to forse proper refresh on sign out / sign in
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTitle("Profile")                

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        path.append(.settings)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationDestination(for: ProfileScreen.self) { profileScreen in
                switch profileScreen {
                case .settings: SettingsView()
                case .followedDaos: FollowedDaosView()
                case .votes: ProfileVotesListView(path: $path)
                case .vote(let proposal):
                    SnapshotProposalView(proposal: proposal,
                                         allowShowingDaoInfo: true,
                                         navigationTitle: proposal.dao.name)

                // Settings
                case .pushNofitications: PushNotificationsSettingView()
                case .about: AboutSettingView()
                case .helpUsGrow: HelpUsGrowSettingView()
                case .partnership: PartnershipSettingView()
                case .advanced: AdvancedSettingView()
                }
            }
        }
    }
}

fileprivate struct _ProfileView: View {
    @Binding var path: [ProfileScreen]

    @StateObject private var dataSource = ProfileDataSource.shared
    @State private var showSignIn = false

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the profile")
            } else if dataSource.profile == nil { // is loading
                ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                ProfileHeaderView(user: profile.account)

                FilterButtonsView<ProfileFilter>(filter: $dataSource.filter) { _ in }

                switch dataSource.filter {
                case .activity:
                    if profile.role == .guest {
                        _SignInToVoteButton {
                            showSignIn = true
                        }
                        .padding(.horizontal, Constants.horizontalPadding)
                        .padding(.vertical, 16)
                    }

                    _ProfileListView(profile: profile, path: $path)
                case .achievements:
                    if profile.role != .guest {
                        AchievementsView()
                    } else {
                        GuestAchievementsView()
                    }
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView { /* do nothing on sign in */ }
                .presentationDetents([.height(500), .large])
        }
        .onAppear {
            Tracker.track(.screenProfile)
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }

    struct _SignInToVoteButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }) {
                HStack {
                    Text("Sign in to vote")
                    Spacer()
                }
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.primary)
                .cornerRadius(12)
                .tint(.onPrimary)
                .font(.headlineSemibold)
            }
        }
    }
}

fileprivate struct _ProfileListView: View {
    let profile: Profile
    @Binding var path: [ProfileScreen]

    var body: some View {
        ScrollView {
            ProfileFollowedDAOsView(profile: profile)

            if let user = profile.account {
                ConnectedWalletView(user: user)

                ProfileVotesView(path: $path)
            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
            FollowedDaosDataSource.followedDaos.refresh()
            ProfileVotesDataSource.shared.refresh()
        }
    }
}
