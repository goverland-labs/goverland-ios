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
    @Setting(\.authToken) private var authToken

    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManager = ActiveSheetManager()

    init(address: Address) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileDataSource(address: address))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if dataSource.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load public user profile")
                } else if dataSource.profile == nil {
                    _ShimmerProfileHeaderView()
                    Spacer()
                } else if let profile = dataSource.profile {
                    _ProfileHeaderView(user: profile.user)

                    FilterButtonsView<PublicUserProfileFilter>(filter: $dataSource.filter) { _ in }
                    
                    switch dataSource.filter {
                    case .activity:
                        PublicUserProfileListView(profile: profile,
                                                  address: dataSource.address,
                                                  activeSheetManager: activeSheetManager,
                                                  path: $path)
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

                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("User profile")
                            .font(.title3Semibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }
            }
            .onAppear {
                Tracker.track(.screenPublicProfile)
                if dataSource.profile == nil {
                    dataSource.refresh()
                }
            }
            .navigationDestination(for: PublicUserProfileScreen.self) { publicUserProfileScreen in
                switch publicUserProfileScreen {
                case .votedInDaos: EmptyView()
                case .votes: EmptyView()
                case .vote(let proposal):
                    SnapshotProposalView(proposal: proposal,
                                         allowShowingDaoInfo: true,
                                         navigationTitle: proposal.dao.name)
                }
            }
            .sheet(item: $activeSheetManager.activeSheet) { item in
                switch item {
                case .signIn:
                    SignInView(source: .popover)

                case .daoInfo(let dao):
                    NavigationViewWithToast {
                        DaoInfoView(dao: dao)
                    }

                case .publicProfile(let address):
                    NavigationViewWithToast {
                        PublicUserProfileView(address: address)
                    }

                case .subscribeToNotifications:
                    EnablePushNotificationsView()

                default:
                    // should not happen
                    EmptyView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
                if activeSheetManager.activeSheet == nil {
                    activeSheetManager.activeSheet = .signIn
                }
            }
            .onChange(of: authToken) { _, token in
                if !token.isEmpty {
                    showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
                }
            }
        }
    }
}

fileprivate struct PublicUserProfileListView: View {
    let profile: PublicUserProfile
    let address: Address
    let activeSheetManager: ActiveSheetManager
    @Binding var path: [PublicUserProfileScreen]

    var body: some View {
        ScrollView {
            VotedInDaosView(profile: profile, activeSheetManager: activeSheetManager)
            PublicUserProfileActivityView(address: address, activeSheetManager: activeSheetManager, path: $path)
        }
    }
}

fileprivate struct VotedInDaosView: View {
    let profile: PublicUserProfile
    let activeSheetManager: ActiveSheetManager

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Voted in DAOs (\(profile.votedInDaos.count))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                NavigationLink("See all", value: PublicUserProfileScreen.votedInDaos)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.primaryDim)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            if profile.votedInDaos.count == 0 {
                Text("User has not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(profile.votedInDaos) { dao in
                            DAORoundViewWithActiveVotes(dao: dao) {
                                activeSheetManager.activeSheet = .daoInfo(dao)
                                Tracker.track(.publicPrfVotedDaoOpen)
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding(.horizontal, 8)
            }
        }
    }
}
