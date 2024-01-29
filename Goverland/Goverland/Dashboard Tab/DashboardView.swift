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
}

struct DashboardView: View {
    @Binding var path: NavigationPath
    @State private var animate = false
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @Setting(\.authToken) private var authToken

    static func refresh() {
        FollowedDAOsActiveVoteDataSource.dashboard.refresh()
        TopProposalsDataSource.dashboard.refresh()
        GroupedDaosDataSource.newDaos.refresh()
        GroupedDaosDataSource.popularDaos.refresh()
        ProfileHasVotingPowerDataSource.dashboard.refresh()
        EcosystemDashboardDataSource.shared.refresh()
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
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Goverland")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear {
                Tracker.track(.screenDashboard)
                animate.toggle()

                if FollowedDAOsActiveVoteDataSource.dashboard.daos.isEmpty {
                    FollowedDAOsActiveVoteDataSource.dashboard.refresh()
                }

                if TopProposalsDataSource.dashboard.proposals.isEmpty {
                    TopProposalsDataSource.dashboard.refresh()
                }

                if GroupedDaosDataSource.newDaos.categoryDaos[.new]?.isEmpty ?? true {
                    GroupedDaosDataSource.newDaos.refresh()
                }

                if GroupedDaosDataSource.newDaos.categoryDaos[.popular]?.isEmpty ?? true {
                    GroupedDaosDataSource.popularDaos.refresh()
                }

                if ProfileHasVotingPowerDataSource.dashboard.proposals?.isEmpty ?? true {
                    ProfileHasVotingPowerDataSource.dashboard.refresh()
                }

                if EcosystemDashboardDataSource.shared.charts == nil {
                    EcosystemDashboardDataSource.shared.refresh()
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
                                               onSelectDaoFromList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashNewDaoOpenFromSearch) },
                                               onFollowToggleFromList: { if $0 { Tracker.track(.dashNewDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { if $0 { Tracker.track(.dashNewDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashNewDao) })
                    .navigationTitle("New DAOs")
                case .popularDaos:
                    FollowCategoryDaosListView(category: .popular,
                                               onSelectDaoFromList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpenFromList) },
                                               onSelectDaoFromSearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpenFromSearch) },
                                               onFollowToggleFromList: { if $0 { Tracker.track(.dashPopularDaoFollowFromList) } },
                                               onFollowToggleFromSearch: { if $0 { Tracker.track(.dashPopularDaoFollowFromSearch) } },
                                               onCategoryListAppear: { Tracker.track(.screenDashPopularDao) })
                case .profileHasVotingPower:
                    ProfileHasVotingPowerFullView(path: $path)
                case .ecosystemCharts:
                    EcosystemChartsFullView()
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: true,
                                     navigationTitle: proposal.dao.name)
            }
        }
    }
}

fileprivate struct SignedOutUserDashboardView: View {
    @Binding var path: NavigationPath
    @Setting(\.welcomeBlockIsRead) var welcomeBlockIsRead

    var body: some View {
        if !welcomeBlockIsRead {
            WelcomeBlockView()
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
        }

        SectionHeader(header: "Popular DAOs") {
            path.append(Path.popularDaos)
        }
        DashboardPopularDaosCardsView()

        // TODO: proposal of the day section

        SectionHeader(header: "Hot Proposals") {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)

        SectionHeader(header: "Ecosystem charts"/*, icon: Image(systemName: "chart.xyaxis.line")*/)
        // Enable after public launch
//                {
//                    path.append(Path.ecosystemCharts)
//                }
        EcosystemDashboardView()
            .padding(.bottom, 40)
    }
}

fileprivate struct SignedInUserDashboardView: View {
    @Binding var path: NavigationPath

    var body: some View {
        // TODO: ProposalOfDayView section

        SectionHeader(header: "Followed DAOs with active vote")
        DashboardFollowedDAOsActiveVoteHorizontalListView()

        SectionHeader(header: "New DAOs") {
            path.append(Path.newDaos)
        }
        DashboardNewDaosView()

        if !(ProfileHasVotingPowerDataSource.dashboard.proposals?.isEmpty ?? false) {
            SectionHeader(header: "You have voting power") {
                path.append(Path.profileHasVotingPower)
            }
            ProfileHasVotingPowerView(path: $path)
        }

        SectionHeader(header: "Popular DAOs") {
            path.append(Path.popularDaos)
        }
        DashboardPopularDaosHorizontalListView()

        SectionHeader(header: "Hot Proposals") {
            path.append(Path.hotProposals)
        }
        DashboardHotProposalsView(path: $path)

        SectionHeader(header: "Ecosystem charts"/*, icon: Image(systemName: "chart.xyaxis.line")*/)
        // TODO: PRO subscription feature
//                {
//                    path.append(Path.ecosystemCharts)
//                }
        EcosystemDashboardView()
            .padding(.bottom, 40)
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
                    welcomeBlockIsRead = true
                }
                Spacer()
            }
            .padding(.top, 16)
        }
        .padding(.vertical, 16)
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
