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
}

struct DashboardView: View {
    @State private var path = NavigationPath()
    @Setting(\.unreadEvents) var unreadEvents
    @State private var animate = false
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    
    static func refresh() {
        RecentlyViewedDaosDataSource.dashboard.refresh()
        TopProposalsDataSource.dashboard.refresh()
        GroupedDaosDataSource.newDaos.refresh()
        GroupedDaosDataSource.popularDaos.refresh()
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                if !RecentlyViewedDaosDataSource.dashboard.recentlyViewedDaos.isEmpty {
                    SectionHeader(header: "Recently Viewed DAOs", onTap: nil)
                    DashboardRecentlyViewedDaosView()
                }
                
                SectionHeader(header: "Hot Proposals") {
                    path.append(Path.hotProposals)
                }
                DashboardHotProposalsView(path: $path)
                
                SectionHeader(header: "New DAOs") {
                    path.append(Path.newDaos)
                }
                DashboardNewDaosView()
                
                SectionHeader(header: "Popular DAOs") {
                    path.append(Path.popularDaos)
                }
                DashboardPopularDaosView()
            }
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
                
                if RecentlyViewedDaosDataSource.dashboard.recentlyViewedDaos.isEmpty {
                    RecentlyViewedDaosDataSource.dashboard.refresh()
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

fileprivate struct SectionHeader: View {
    let header: String
    let onTap: (() -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)
            
            HStack {
                Text(header)
                    .font(.title2Semibold)
                Spacer()
                if onTap != nil {
                    Image(systemName: "arrow.right")
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
