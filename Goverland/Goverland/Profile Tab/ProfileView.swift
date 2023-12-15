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

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the profile")
            } else if dataSource.profile == nil { // is loading
                ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                ProfileHeaderView(user: profile.account)
                ProfileListView(profile: profile)
            }
        }
        .onAppear {
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct ProfileHeaderView: View {
    let user: User?

    var body: some View {
        VStack(alignment: .center) {
            if let user {
                RoundPictureView(image: user.avatars.first { $0.size == .l }?.link,
                                 imageSize: User.AvatarSize.l.imageSize)
            } else {
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.containerBright)
            }

            ZStack {
                if let name = user?.resolvedName {
                    Text(name)
                        .truncationMode(.tail)
                } else {
                    Text("Unnamed")
                }
            }
            .font(.title3Semibold)
            .lineLimit(1)
            .foregroundColor(.textWhite)
        }
        .padding(24)
    }
}

fileprivate struct ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: 70, height: 70)
                .cornerRadius(35)

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
            Section {
                NavigationLink("My followed DAOs", value: ProfileScreen.subscriptions)
                NavigationLink("Notifications", value: ProfileScreen.pushNofitications)
            }

            Section(header: Text("Devices")) {
                ForEach(profile.sessions) { s in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.deviceName)
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)
                            
                            if s.lastActivity + 10.minutes > .now {
                                Text("Online")
                                    .font(.footnoteRegular)
                                    .foregroundColor(.textWhite60)
                            } else {
                                let activity = s.lastActivity.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full)
                                Text("Last activity \(activity)")
                                    .font(.footnoteRegular)
                                    .foregroundColor(.textWhite60)
                            }
                        }
                        Spacer()
                    }
                }
            }

            Section() {
                Button("Sign out") {
                    isSignOutPopoverPresented.toggle()
                }
                .tint(Color.textWhite)


            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
        }
        .popover(isPresented: $isSignOutPopoverPresented) {
            SignOutPopoverView()
                .presentationDetents([.fraction(0.15)])
        }
    }
}
