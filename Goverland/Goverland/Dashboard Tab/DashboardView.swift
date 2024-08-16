//
//  DashboardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Version

fileprivate enum Path {
    case hotProposals
    case newDaos
    case popularDaos
    case profileHasVotingPower
    case ecosystemCharts
}

struct DashboardView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    @Setting(\.authToken) private var authToken

    @Setting(\.lastWhatsNewVersionDisplaied) private var lastWhatsNewVersionDisplaied
    @State private var showWhatsNew = false

    static func refresh() {
        FeaturedProposalsDataSource.dashboard.refresh()
        FollowedDAOsActiveVoteDataSource.dashboard.refresh()
        TopProposalsDataSource.dashboard.refresh()
        GroupedDaosDataSource.dashboard.refresh()
        ProfileHasVotingPowerDataSource.dashboard.refresh()
//        EcosystemDashboardDataSource.shared.refresh()
        StatsDataSource.shared.refresh()
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                if !authToken.isEmpty {
                    SignedInUserDashboardView(path: $path)
                } else {
                    SignedOutUserDashboardView(path: $path)
                }
            }
            .id(authToken) // redraw completely on auth token change
            .onChange(of: authToken) { _, _ in
                Self.refresh()
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTitle("Goverland")                
            }
            .onAppear {
                Tracker.track(.screenDashboard)

                if let versionNumber = Bundle.main.releaseVersionNumber, versionNumber != lastWhatsNewVersionDisplaied {
                    WhatsNewDataSource.shared.loadData { latestVersion in
                        guard latestVersion.description == versionNumber else {
                            // might happen if release is there, but we haven't added
                            // what's new description for this version
                            return
                        }
                        showWhatsNew = true
                        lastWhatsNewVersionDisplaied = versionNumber
                    }
                }

                if FeaturedProposalsDataSource.dashboard.proposals?.isEmpty ?? true {
                    FeaturedProposalsDataSource.dashboard.refresh()
                }

                if FollowedDAOsActiveVoteDataSource.dashboard.subscriptions.isEmpty {
                    FollowedDAOsActiveVoteDataSource.dashboard.refresh()
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
                                               onSelectDaoFromList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpenFromSearch) },
                                               onFollowToggleFromList: { didFollow in if didFollow { Tracker.track(.dashNewDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { didFollow in if didFollow { Tracker.track(.dashNewDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashNewDao) })
                    .navigationTitle("New DAOs")
                case .popularDaos:
                    FollowCategoryDaosListView(category: .popular,
                                               onSelectDaoFromList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpenFromSearch) },
                                               onFollowToggleFromList: { didFollow in if didFollow { Tracker.track(.dashPopularDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { didFollow in if didFollow { Tracker.track(.dashPopularDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashPopularDao) })
                case .profileHasVotingPower:
                    ProfileHasVotingPowerFullView(path: $path)
                case .ecosystemCharts:
                    EcosystemChartsFullView()
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal)
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

        SectionHeader(header: "Hot Proposals") {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)
            .padding(.bottom, 30)

//        SectionHeader(header: "Ecosystem charts"/*, icon: Image(systemName: "chart.xyaxis.line")*/)
//        // Enable after public launch
////                {
////                    path.append(Path.ecosystemCharts)
////                }
//        EcosystemDashboardView()
//            .padding(.bottom, 40)
    }
}

fileprivate struct SignedInUserDashboardView: View {
    @Binding var path: NavigationPath
    @StateObject private var followedDaosWithActiveVoteDataSource = FollowedDAOsActiveVoteDataSource.dashboard
    @StateObject private var profileHasVotingPowerDataSource = ProfileHasVotingPowerDataSource.dashboard
    @StateObject private var featuredDataSource = FeaturedProposalsDataSource.dashboard

    var shouldShowDaosWithActiveVote: Bool {
        !followedDaosWithActiveVoteDataSource.subscriptions.isEmpty || followedDaosWithActiveVoteDataSource.isLoading
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

    var body: some View {
        if shouldShowFeaturedProposal {
            SectionHeader(header: "Proposal of the day")
            FeaturedProposalsView(path: $path)
        }

        if shouldShowDaosWithActiveVote {
            SectionHeader(header: "Followed DAOs with active vote")
            DashboardFollowedDAOsActiveVoteHorizontalListView()
        }

        if shouldShowRecommendationToVote {
            SectionHeader(header: "You have voting power") {
                path.append(Path.profileHasVotingPower)
            }
            ProfileHasVotingPowerView(path: $path)
        }

        SectionHeader(header: "Hot Proposals") {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)

        SectionHeader(header: "Popular DAOs") {
            path.append(Path.popularDaos)
        }
        DashboardPopularDaosHorizontalListView()

        SectionHeader(header: "New DAOs") {
            path.append(Path.newDaos)
        }
        DashboardNewDaosView()
            .padding(.bottom, 30)

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
    let icon: Image
    let onTap: (() -> Void)?

    init(header: String, 
         icon: Image = Image(systemName: "arrow.right"),
         onTap: (() -> Void)? = nil) {
        self.header = header
        self.icon = icon
        self.onTap = onTap
    }

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)

            HStack {
                Text(header)
                    .font(.title2Semibold)
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
