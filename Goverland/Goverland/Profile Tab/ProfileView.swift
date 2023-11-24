//
//  ProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

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
    @Setting(\.authToken) var authToken

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
                        Image(systemName: "gearshape")
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
        VStack {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else if dataSource.profile == nil { // is loading
                // TODO: use ProfileHeaderShimmerView
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                    .padding(.top, 16)
                Spacer()
            } else if let profile = dataSource.profile {
                ProfileHeaderView(user: profile.accounts.first!)
                ProfileListView(profile: profile)
            }
        }
        .onAppear {
            dataSource.refresh()
        }
    }
}

fileprivate struct ProfileHeaderView: View {
    let user: User

    var body: some View {
        VStack(alignment: .center) {
            RoundPictureView(image: user.avatar, imageSize: 70)

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
            .foregroundColor(.textWhite)
        }
        .padding(26)
    }
}

fileprivate struct ProfileListView: View {
    let profile: Profile

    var user: User {
        profile.accounts.first!
    }

    @State private var isDeleteProfilePopoverPresented = false
    @State private var isSignOutPopoverPresented = false

    var body: some View {
        List {
            Section {
                NavigationLink("My followed DAOs", value: ProfileScreen.subscriptions)
            }

            // TODO: place notifications here

            Section {
                HStack {
                    Text("Accounts")
                    Spacer()
                }
                .foregroundColor(Color.onPrimary)
                .listRowBackground(Color.primaryDim)

                HStack(spacing: 8) {
                    UserPictureView(user: user, imageSize: 20)

                    if let name = user.resolvedName {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.resolvedName!)
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)
                            Text(user.address.short)
                                .font(.сaptionRegular)
                                .foregroundColor(.textWhite60)
                        }
                    } else {
                        Text(user.address.short)
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                    }

                    Spacer()
                }
            }

//            Section(header: Text("Devices")) {
//                ForEach(devices.indices) { i in
//                    NavigationLink("", destination: EmptyView())
//                        .frame(height: 40)
//                        .background(
//                            HStack {
//                                VStack(alignment: .leading, spacing: 5) {
//                                    Text(devices[i][0])
//                                        .font(.bodyRegular)
//                                        .foregroundColor(.textWhite)
//                                    Text("\(devices[i][1]) - \(devices[i][2])")
//                                        .font(.footnoteRegular)
//                                        .foregroundColor(.textWhite60)
//                                }
//                                Spacer()
//                            }
//                        )}
//            }

            Section() {
                Button("Sign out") {
                    isSignOutPopoverPresented.toggle()
                }
                .tint(Color.textWhite)

                Button("Delete profile") {
                    isDeleteProfilePopoverPresented.toggle()
                }
                .tint(Color.textWhite)
            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
        }
        .sheet(isPresented: $isDeleteProfilePopoverPresented) {
            DeleteProfilePopoverView()
                .presentationDetents([.medium, .large])
        }
        .popover(isPresented: $isSignOutPopoverPresented) {
            SignOutPopoverView()
                .presentationDetents([.fraction(0.15)])
        }
    }
}
