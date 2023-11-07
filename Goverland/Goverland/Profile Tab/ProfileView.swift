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
        if authToken.isEmpty {
            SignInView()
        } else {
            UserProfileView(path: $path)
        }
    }
}

fileprivate struct UserProfileView: View {
    @Binding var path: [ProfileScreen]

    @State private var isDeleteProfilePopoverPresented = false
    @State private var isSignOutPopoverPresented = false

    private let user = User.aaveChan
    private let devices = [["IPhone 14 Pro", "Sandefjord, Norway", "online"],
                           ["IPhone 13", "Tbilisi, Georgia", "Apr 10"]]

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 70, height: 70)
                Text((user.resolvedName != nil) ? user.resolvedName! : "Unnamed")
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
            }
            List {
                Section {
                    NavigationLink("My followed DAOs", value: ProfileScreen.subscriptions)
                }

                Section() {
                    NavigationLink("", destination: EmptyView())
                        .background(
                            HStack {
                                Text("Accounts")
                                Spacer()
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 17)
                                    .foregroundColor(Color.onPrimary)
                            }
                                .foregroundColor(Color.onPrimary)
                        )
                        .listRowBackground(Color.primaryDim)

                    if user.resolvedName != nil {
                        NavigationLink("", destination: EmptyView())
                            .frame(height: 40)
                            .background(
                                HStack {
                                    Image(systemName: "circle")
                                        .frame(width:20, height: 20)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(user.resolvedName!)
                                            .font(.bodyRegular)
                                            .foregroundColor(.textWhite)
                                        Text(user.address.short)
                                            .font(.сaptionRegular)
                                            .foregroundColor(.textWhite60)
                                    }
                                    Spacer()
                                })
                    }

                    NavigationLink("", destination: EmptyView())
                        .background(
                            HStack {
                                HStack {
                                    Image(systemName: "circle")
                                        .frame(width:20, height: 20)
                                    Text(user.address.short)
                                        .font(.bodyRegular)
                                        .foregroundColor(.textWhite)
                                }
                                Spacer()
                            })
                }

                Section(header: Text("Devices")) {
                    ForEach(devices.indices) { i in
                        NavigationLink("", destination: EmptyView())
                            .frame(height: 40)
                            .background(
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(devices[i][0])
                                            .font(.bodyRegular)
                                            .foregroundColor(.textWhite)
                                        Text("\(devices[i][1]) - \(devices[i][2])")
                                            .font(.footnoteRegular)
                                            .foregroundColor(.textWhite60)
                                    }
                                    Spacer()
                                }
                            )}
                }

                Section() {
                    Button("Sign out") {
                        isSignOutPopoverPresented.toggle()
                    }
                    .tint(Color.textWhite)
                }
            }
            .navigationTitle("My profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        path.append(.settings)
                    } label: {
                        Image("settings-active")
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            isDeleteProfilePopoverPresented.toggle()
                        } label: {
                            Label("Delete Profile", systemImage: "trash.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
            .navigationDestination(for: ProfileScreen.self) { profileScreen in
                switch profileScreen {
                case .settings: SettingsView(path: $path)
                case .subscriptions: SubscriptionsView()
                case .pushNofitications: PushNotificationsSettingView()
                case .about: AboutSettingView()
                case .helpUsGrow: HelpUsGrowSettingView()
                case .partnership: PartnershipSettingView()
                case .advanced: AdvancedSettingView()
                }
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
}
