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
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Profile")
                            .font(.title3Semibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }

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
                _ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                _ProfileHeaderView(user: profile.account)

                FilterButtonsView<ProfileFilter>(filter: $dataSource.filter) { _ in }

                switch dataSource.filter {
                case .activity:
                    if profile.role == .guest {
                        _SignInToVoteButton {
                            showSignIn = true
                        }
                        .padding(.horizontal, 12)
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
            SignInTwoStepsView()
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

fileprivate struct _ProfileHeaderView: View {
    let user: User?

    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 12) {
                if let user {
                    RoundPictureView(image: user.avatar(size: .l), imageSize: Avatar.Size.l.profileImageSize)
                    ZStack {
                        if let name = user.resolvedName {
                            Text(name)
                                .truncationMode(.tail)
                        } else {
                            Button {
                                UIPasteboard.general.string = user.address.value
                                showToast("Address copied")
                            } label: {
                                Text(user.address.short)
                            }
                        }
                    }
                    .font(.title3Semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.textWhite)
                } else { // Guest profile
                    Image("guest-profile")
                        .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("Guest")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding(.bottom, 6)
        }
        .padding(24)
    }

    struct CounterView: View {
        let counter: Int
        let title: String

        var body: some View {
            VStack(spacing: 4) {
                Text("\(counter)")
                    .font(.bodySemibold)
                    .foregroundStyle(Color.textWhite)
                Text(title)
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite60)
            }
        }
    }
}


struct _ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                .cornerRadius(Avatar.Size.l.profileImageSize / 2)

            ShimmerView()
                .cornerRadius(24)
                .frame(width: 100, height: 24)
        }
        .padding(24)
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
