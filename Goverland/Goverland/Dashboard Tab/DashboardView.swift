//
//  DashboardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

fileprivate enum Path {
    case hotProposals
    case newDaos
    case popularDaos
    case profileHasVotingPower
    case ecosystemCharts
    case voteNow
}

struct DashboardView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    @Setting(\.authToken) private var authToken
    @Setting(\.lastWhatsNewVersionDisplaied) private var lastWhatsNewVersionDisplaied
    @Setting(\.unreadEvents) private var unreadEvents

    @State private var showWhatsNew = false

    static func refresh() {
        FeaturedProposalsDataSource.dashboard.refresh()
        FollowedDaosDataSource.horizontalList.refresh()
        VoteNowDataSource.dashboard.refresh()
        TopProposalsDataSource.dashboard.refresh()
        GroupedDaosDataSource.dashboard.refresh()
        ProfileHasVotingPowerDataSource.dashboard.refresh()
//        EcosystemDashboardDataSource.shared.refresh()
        StatsDataSource.shared.refresh()
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Group {
                    if !authToken.isEmpty {
                        SignedInUserDashboardView(path: $path)
                    } else {
                        SignedOutUserDashboardView(path: $path)
                    }
                }
                .padding(.bottom, 30)
            }
            .id(authToken) // redraw completely on auth token change
            .onChange(of: authToken) { _, _ in
                Self.refresh()
            }
            .onReceive(NotificationCenter.default.publisher(for: .appEnteredForeground)) { _ in
                if path.isEmpty {
                    Self.refresh()
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTitle("Goverland")

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheetManager.activeSheet = .notifications
                        // always refresh datasource when opening a popover
                        // to fetch the latest data
                        InboxDataSource.shared.refresh()
                    } label: {
                        HStack(spacing: 2) {
                            if unreadEvents > 0 {
                                Text("\(unreadEvents)")
                                    .font(.сaption2Regular)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(
                                        Group {
                                            if unreadEvents < 10 {
                                                Circle().foregroundStyle(Color.red)
                                            } else {
                                                Capsule().foregroundStyle(Color.red)
                                            }
                                        }
                                    )
                                    .foregroundStyle(Color.textWhite)
                                    .lineLimit(1)
                        }
                            Image(systemName: "bell.fill")
                        }
                    }
                }
            }
            .onAppear {
                Tracker.track(.screenDashboard)

                if WhatsNewDataSource.shared.appVersion.description != lastWhatsNewVersionDisplaied {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        // Versions data is loaded on App launch.
                        // If data is not loaded within 1 sec, What's new dialogue will not be displayed.
                        // But it will be displayed on the next Dashboard tab selection if loaded.
                        guard WhatsNewDataSource.shared.latestVersionIsAppVerion else {
                            // might happen if release is there, but we haven't added
                            // what's new description for this version
                            return
                        }
                        showWhatsNew = true
                        lastWhatsNewVersionDisplaied = WhatsNewDataSource.shared.appVersion.description
                    }
                }

                if FeaturedProposalsDataSource.dashboard.proposals?.isEmpty ?? true {
                    FeaturedProposalsDataSource.dashboard.refresh()
                }

                if FollowedDaosDataSource.horizontalList.subscriptions.isEmpty {
                    FollowedDaosDataSource.horizontalList.refresh()
                }

                if VoteNowDataSource.dashboard.proposals?.isEmpty ?? true {
                    VoteNowDataSource.dashboard.refresh()
                }

                if TopProposalsDataSource.dashboard.proposals.isEmpty {
                    TopProposalsDataSource.dashboard.refresh()
                }

                // refresh if dao/top is not loaded
                if GroupedDaosDataSource.dashboard.categoryDaos[.popular]?.isEmpty ?? true {
                    GroupedDaosDataSource.dashboard.refresh()
                }

                if ProfileHasVotingPowerDataSource.dashboard.proposals?.isEmpty ?? true {
                    ProfileHasVotingPowerDataSource.dashboard.refresh()
                }

//                if EcosystemDashboardDataSource.shared.charts == nil {
//                    EcosystemDashboardDataSource.shared.refresh()
//                }

                if StatsDataSource.shared.stats == nil {
                    StatsDataSource.shared.refresh()
                }
            }
            .refreshable {
                Self.refresh()
            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .hotProposals:
                    TopProposalsListView(dataSource: TopProposalsDataSource.dashboard,
                                         path: $path,
                                         screenTrackingEvent: .screenDashHotList,
                                         openProposalFromListItemTrackingEvent: .dashHotOpenPrpFromList,
                                         openDaoFromListItemTrackingEvent: .dashHotOpenDaoFromList)
                    .navigationTitle("Hot Proposals")
                case .newDaos:
                    FollowCategoryDaosListView(category: .new,
                                               onSelectDaoFromList: { dao in activeSheetManager.activeSheet = .daoInfoById(dao.id.uuidString); Tracker.track(.dashNewDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManager.activeSheet = .daoInfoById(dao.id.uuidString); Tracker.track(.dashNewDaoOpenFromSearch) },
                                               onFollowToggleFromList: { didFollow in if didFollow { Tracker.track(.dashNewDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { didFollow in if didFollow { Tracker.track(.dashNewDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashNewDao) })
                    .navigationTitle("New DAOs")
                case .popularDaos:
                    FollowCategoryDaosListView(category: .popular,
                                               onSelectDaoFromList: { dao in activeSheetManager.activeSheet = .daoInfoById(dao.id.uuidString); Tracker.track(.dashPopularDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManager.activeSheet = .daoInfoById(dao.id.uuidString); Tracker.track(.dashPopularDaoOpenFromSearch) },
                                               onFollowToggleFromList: { didFollow in if didFollow { Tracker.track(.dashPopularDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { didFollow in if didFollow { Tracker.track(.dashPopularDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashPopularDao) })
                case .profileHasVotingPower:
                    ProfileHasVotingPowerFullView(path: $path)
                case .ecosystemCharts:
                    EcosystemChartsFullView()
                case .voteNow:
                    VoteNowFullListView(path: $path)
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                // We want to always load data from backend as Top proposals are cached for some time
                // so we use initializer with proposal.id instead of passing the cached proposal object
                SnapshotProposalView(proposalId: proposal.id)
            }
            .sheet(isPresented: $showWhatsNew) {
                NavigationStack {
                    WhatsNewView(displayCloseButton: true)
                }
            }
        }
    }
}

fileprivate struct SignedOutUserDashboardView: View {
    @Binding var path: NavigationPath
    @Setting(\.welcomeBlockIsRead) var welcomeBlockIsRead
    @StateObject private var featuredDataSource = FeaturedProposalsDataSource.dashboard

    var shouldShowFeaturedProposal: Bool {
        guard let proposals = featuredDataSource.proposals else { return true }
        return !proposals.isEmpty
    }

    var body: some View {
        if !welcomeBlockIsRead {
            WelcomeBlockView()
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, 16)
        }

        SectionHeader(header: "Popular DAOs") {
            path.append(Path.popularDaos)
        }
        DashboardPopularDaosCardsView()

        if shouldShowFeaturedProposal {
            SectionHeader(header: "Proposal of the day")
            FeaturedProposalsView(path: $path)
        }

        SectionHeader(header: "Hot ecosystem proposals", headerIcon: Image(systemName: "flame.fill")) {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)

        SectionHeader(header: "New DAOs") {
            path.append(Path.newDaos)
        }
        DashboardNewDaosView()

//        SectionHeader(header: "Ecosystem charts"/*, icon: Image(systemName: "chart.xyaxis.line")*/)
//        // Enable after public launch
////                {
////                    path.append(Path.ecosystemCharts)
////                }
//        EcosystemDashboardView()
    }
}

fileprivate struct SignedInUserDashboardView: View {
    @Binding var path: NavigationPath
    @StateObject private var followedDaosDataSource = FollowedDaosDataSource.horizontalList
    @StateObject private var voteNowDataSource = VoteNowDataSource.dashboard
    @StateObject private var profileHasVotingPowerDataSource = ProfileHasVotingPowerDataSource.dashboard
    @StateObject private var featuredDataSource = FeaturedProposalsDataSource.dashboard

    var shouldShowFollowedDaos: Bool {
        !followedDaosDataSource.subscriptions.isEmpty || followedDaosDataSource.isLoading
    }

    var shouldShowRecommendationToVote: Bool {
        guard ProfileDataSource.shared.profile?.role == .regular else { return false }
        if let proposals = profileHasVotingPowerDataSource.proposals {
            return !proposals.isEmpty
        } else {
            return true
        }
    }

    var shouldShowFeaturedProposal: Bool {
        guard let proposals = featuredDataSource.proposals else { return true }
        return !proposals.isEmpty
    }

    var shouldShowVoteNow: Bool {
        guard let proposals = voteNowDataSource.proposals else { return true }
        return !proposals.isEmpty
    }

    var body: some View {
        if shouldShowFollowedDaos {
            SectionHeader(header: "My followed DAOs")
            FollowedDAOsHorizontalListView()
        }

        if shouldShowFeaturedProposal {
            SectionHeader(header: "Proposal of the day")
            FeaturedProposalsView(path: $path)
        }

        if shouldShowVoteNow {
            SectionHeader(header: "Vote now", headerIcon: Image("vote-now")) {
                path.append(Path.voteNow)
            }
            VoteNowView(path: $path)
        }

        SectionHeader(header: "Hot ecosystem proposals", headerIcon: Image(systemName: "flame.fill")) {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)

        SectionHeader(header: "Popular DAOs") {
            path.append(Path.popularDaos)
        }
        DashboardPopularDaosHorizontalListView()

        if shouldShowRecommendationToVote {
            SectionHeader(header: "Discover where you can vote") {
                path.append(Path.profileHasVotingPower)
            }
            ProfileHasVotingPowerView(path: $path)
        }

        SectionHeader(header: "New DAOs") {
            path.append(Path.newDaos)
        }
        DashboardNewDaosView()

//        SectionHeader(header: "Ecosystem charts"/*, icon: Image(systemName: "chart.xyaxis.line")*/)
////                {
////                    path.append(Path.ecosystemCharts)
////                }
//        EcosystemDashboardView()
//            .padding(.bottom, 40)
    }
}

fileprivate struct WelcomeBlockView: View {
    @Setting(\.welcomeBlockIsRead) var welcomeBlockIsRead

    var body: some View {
        VStack {
            Text("Welcome to Goverland,\nYour App for all DAOs!")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 8) {
                BulletItem(image: "fireworks", text: "This is your Home page with personalized recommendations")
                BulletItem(image: "globe", text: "Discover new trends")
                BulletItem(image: "checkmark.bubble", text: "Follow DAOs to be up to date")
                BulletItem(image: "flag.checkered", text: "Sign in with your Wallet and vote")
            }

            HStack {
                Spacer()
                PrimaryButton("Okay, let's go!", 
                              maxWidth: 140,
                              height: 32,
                              font: .footnoteSemibold) {
                    Haptic.medium()
                    welcomeBlockIsRead = true
                }
                Spacer()
            }
            .padding(.top, 16)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
        )
    }

    struct BulletItem: View {
        let image: String
        let text: String

        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                Image(image)
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                Text(text)
                    .font(.subheadlineRegular)
                    .foregroundStyle(Color.textWhite)
            }
        }
    }
}

fileprivate struct SectionHeader: View {
    let header: String
    let headerIcon: Image?
    let icon: Image
    let onTap: (() -> Void)?

    init(header: String,
         headerIcon: Image? = nil,
         icon: Image = Image(systemName: "arrow.right"),
         onTap: (() -> Void)? = nil) {
        self.header = header
        self.headerIcon = headerIcon
        self.icon = icon
        self.onTap = onTap
    }

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)

            HStack {
                HStack {
                    if let headerIcon = headerIcon {
                        headerIcon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                    }
                    Text(header)
                        .font(.title2Semibold)
                }
                Spacer()
                if onTap != nil {
                    icon
                        .font(.title2)
                }
            }
            .padding(.horizontal, 24)
            .foregroundStyle(Color.textWhite)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap?()
            }
        }
    }
}
