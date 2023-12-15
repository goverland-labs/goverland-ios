//
//  ProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftDate

enum ProfileScreen {
    case settings
    case subscriptions

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
                    SignInView()
                } else {
                    _ProfileView()
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Profile")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
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
                case .subscriptions: SubscriptionsView()

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

                if profile.role == .guest {
                    SignInToVoteButton {
                        showSignIn = true
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }

                ProfileListView(profile: profile)
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView()
                .presentationDetents([.height(500), .large])
        }
        .onAppear {
            // TODO: track
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }

    struct SignInToVoteButton: View {
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
                .padding(.horizontal, 18)
                .background(Color.primary)
                .cornerRadius(12)
                .tint(.onPrimary)
                .font(.headlineSemibold)
            }
        }
    }
}

fileprivate struct ProfileHeaderView: View {
    let user: User?

    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 12) {
                if let user {
                    RoundPictureView(image: user.avatars.first { $0.size == .l }?.link,
                                     imageSize: User.AvatarSize.l.imageSize)
                    ZStack {
                        if let name = user.resolvedName {
                            Text(name)
                                .truncationMode(.tail)
                        } else {
                            Text("Unnamed")
                        }
                    }
                    .font(.title3Semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.textWhite)
                } else { // Guest profile
                    Image("guest-profile")
                        .frame(width: User.AvatarSize.l.imageSize, height: User.AvatarSize.l.imageSize)
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("Guest")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding(.bottom, 16)

            // TODO: get the real data
            HStack {
                Spacer()
                CounterView(counter: 0, title: "Votes")
                Spacer()
                Spacer()
                    .frame(width: 1)
                Spacer()
                CounterView(counter: 12, title: "Following DAOs")
                Spacer()
            }
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


fileprivate struct ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: 72, height: 72)
                .cornerRadius(36)

            ShimmerView()
                .cornerRadius(24)
                .frame(width: 100, height: 24)
        }
        .padding(24)
    }
}

fileprivate struct ProfileListView: View {
    let profile: Profile

    var user: User? {
        profile.account
    }

    @State private var isSignOutPopoverPresented = false

    var body: some View {
        List {
            Section("Goverland") {
                NavigationLink("My followed DAOs", value: ProfileScreen.subscriptions)
                NavigationLink("Notifications", value: ProfileScreen.pushNofitications)
            }

            Section("Devices") {
                ForEach(profile.sessions) { s in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.deviceName)
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)
                            
                            // TODO: change in 0.6
                            if s.id.uuidString.lowercased() == SettingKeys.shared.authToken.lowercased() {
                                Text("Online")
                                    .font(.footnoteRegular)
                                    .foregroundColor(.textWhite60)
                            } else {
                                let created = s.created.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
                                Text("Session created \(created)")
                                    .font(.footnoteRegular)
                                    .foregroundColor(.textWhite60)
                            }

//                            if s.lastActivity + 10.minutes > .now {
//                                Text("Online")
//                                    .font(.footnoteRegular)
//                                    .foregroundColor(.textWhite60)
//                            } else {
//                                let activity = s.lastActivity.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
//                                Text("Last activity \(activity)")
//                                    .font(.footnoteRegular)
//                                    .foregroundColor(.textWhite60)
//                            }
                        }
                        Spacer()
                    }
                    .swipeActions {
                        Button {
                            ProfileDataSource.shared.signOut(sessionId: s.id.uuidString)
                            // TODO: track
                        } label: {
                            Text("Sign out")
                                .font(.bodyRegular)
                        }
                        .tint(.red)
                    }
                }
            }
            if profile.role == .regular {
                Section() {
                    Button("Sign out") {
                        isSignOutPopoverPresented.toggle()
                    }
                    .tint(Color.textWhite)
                }
            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
        }
        .popover(isPresented: $isSignOutPopoverPresented) {
            SignOutPopoverView()
                .presentationDetents([.height(128)])
        }
    }
}
