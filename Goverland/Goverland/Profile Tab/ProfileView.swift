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
    case inboxSettings
    case about
    case helpUsGrow
    case partnership
    case advanced
    case whatsNew
}

extension ProfileFilter {
    var content: some View {
        Group {
            if self == .achievements {
                HStack(spacing: 6) {
                    if AchievementsDataSource.shared.hasUnreadAchievements() {
                        Circle()
                            .foregroundStyle(Color.primary)
                            .frame(width: 4, height: 4)
                    }
                    Text(localizedName)
                }
            } else {
                Text(localizedName)
            }
        }
    }
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
                case .followedDaos: FollowedDaosListView()
                case .votes: ProfileVotesListView(path: $path)
                case .vote(let proposal):
                    SnapshotProposalView(proposal: proposal)

                // Settings
                case .pushNofitications: PushNotificationsSettingView()
                case .inboxSettings: InboxSettingView(showPushSettings: false)
                case .about: AboutSettingView()
                case .helpUsGrow: HelpUsGrowSettingView()
                case .partnership: PartnershipSettingView()
                case .advanced: AdvancedSettingView()
                case .whatsNew: WhatsNewView(displayCloseButton: false)
                }
            }
        }
    }
}

fileprivate struct _ProfileView: View {
    @Binding var path: [ProfileScreen]

    @StateObject private var profileDataSource = ProfileDataSource.shared
    @StateObject private var achievementsDataSource = AchievementsDataSource.shared
    @State private var showSignIn = false

    var body: some View {
        Group {
            if profileDataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: profileDataSource, message: "Sorry, we couldn’t load the profile")
            } else if profileDataSource.profile == nil { // is loading
                ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = profileDataSource.profile {
                ProfileHeaderView(user: profile.account, publicUser: false)

                FilterButtonsView<ProfileFilter>(filter: $profileDataSource.filter)
                    .id(achievementsDataSource.hasUnreadAchievements()) // redraw once we get achievements data

                switch profileDataSource.filter {
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
                    if profile.role == .guest {
                        GuestAchievementsView()
                    } else {
                        AchievementsView()
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
            if profileDataSource.profile == nil {
                profileDataSource.refresh()
            }
            if achievementsDataSource.achievements.isEmpty {
                achievementsDataSource.refresh()
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
                .padding(.horizontal, Constants.horizontalPadding)
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
            if let user = profile.account { // signed in
                ConnectedWalletView(user: user)
            }

            ProfileFollowedDAOsView(profile: profile)
            
            MyDelegatesView()

            if profile.account != nil {
                ProfileVotesView(path: $path)
            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
            FollowedDaosDataSource.horizontalList.refresh()
            ProfileVotesDataSource.shared.refresh()
        }
    }
}
