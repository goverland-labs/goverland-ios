//
//  DashboardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import SwiftUI

fileprivate enum Path {
    case hotProposals
    case newDaos
}

struct DashboardView: View {
    @State private var path = NavigationPath()
    @Setting(\.unreadEvents) var unreadEvents
    @State private var animate = false
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    static func refresh() {
        TopProposalsDataSource.dashboard.refresh()
        GroupedDaosDataSource.dashboard.refresh()
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                SectionHeader(header: "Hot Proposals") {
                    path.append(Path.hotProposals)
                }
                DashboardHotProposalsView(path: $path)

                SectionHeader(header: "New DAOs") {
                    path.append(Path.newDaos)
                }
                DashboardNewDaosView()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    if #available(iOS 17, *) {
                        if unreadEvents > 0 {
                            Image(systemName: "envelope.badge")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.primary, Color.textWhite)
                                .symbolEffect(.bounce.up.byLayer, options: .speed(0.3), value: animate)
                                .onTapGesture {
                                    ActiveHomeViewManager.shared.activeView = .inbox
                                }
                        } else {
                            Image(systemName: "envelope")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.textWhite, Color.textWhite)
                                .onTapGesture {
                                    ActiveHomeViewManager.shared.activeView = .inbox
                                }
                        }
                    } else {
                        Image(systemName: unreadEvents > 0 ? "envelope.badge" : "envelope")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(unreadEvents > 0 ? Color.primary : Color.textWhite, Color.textWhite)
                            .onTapGesture {
                                ActiveHomeViewManager.shared.activeView = .inbox
                            }
                    }
                }
            }
            .onAppear {
                Tracker.track(.screenDashboard)
                animate.toggle()
                if TopProposalsDataSource.dashboard.proposals.isEmpty {
                    TopProposalsDataSource.dashboard.refresh()
                }
                
                if GroupedDaosDataSource.dashboard.categoryDaos[.new]?.isEmpty ?? true {
                    GroupedDaosDataSource.dashboard.refresh()
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
