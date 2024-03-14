//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @StateObject var model = SearchModel.shared

    @StateObject var daos = GroupedDaosDataSource.search
    @StateObject var daosSearch = DaosSearchDataSource.shared
    @StateObject var proposals = TopProposalsDataSource.search
    @StateObject var proposalsSearch = ProposalsSearchDataSource()

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    private var searchPrompt: String {
        switch model.filter {
        case .daos:
            if let total = daos.totalDaos {
                let totalStr = Utils.formattedNumber(Double(total))
                return "Search for \(totalStr) DAOs by name"
            }
            return ""
        case .proposals:
            if let total = proposals.totalProposals {
                let totalStr = Utils.formattedNumber(Double(total))
                return "Search for \(totalStr) proposals by name"
            }
            return ""
        }
    }

    private var searchText: Binding<String> {
        switch model.filter {
        case .daos:
            return $daosSearch.searchText
        case .proposals:
            return $proposalsSearch.searchText
        }
    }
    
    var body: some View {
        NavigationStack(path: $model.path) {
            VStack(spacing: 0) {
                FilterButtonsView<SearchFilter>(filter: $model.filter) { _ in }

                if searchText.wrappedValue == "" {
                    switch model.filter {
                    case .daos:
                        ZStack {
                            if !daos.failedToLoadInitialData {
                                GroupedDaosView(dataSource: daos,
                                                showRecentlyViewedDAOs: true,                                                
                                                onSelectDaoFromGroup: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCard) },
                                                onSelectDaoFromCategoryList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgList) },
                                                onSelectDaoFromCategorySearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgSearch) },

                                                onFollowToggleFromCard: { if $0 { Tracker.track(.searchDaosFollowFromCard) } },
                                                onFollowToggleFromCategoryList: { if $0 { Tracker.track(.searchDaosFollowFromCtgList) } },
                                                onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.searchDaosFollowFromCtgSearch) } },

                                                onCategoryListAppear: { Tracker.track(.screenSearchDaosCtgDaos) })
                            } else {
                                RetryInitialLoadingView(dataSource: daos, message: "Sorry, we couldn’t load DAOs")
                            }
                        }
                        .onAppear() {
                            Tracker.track(.screenSearchDaos)
                        }
                    case .proposals:
                        if !proposals.failedToLoadInitialData {
                            TopProposalsListView(dataSource: proposals, 
                                                 path: $model.path,
                                                 screenTrackingEvent: .screenSearchPrp,
                                                 openProposalFromListItemTrackingEvent: .searchPrpOpenFromCard,
                                                 openDaoFromListItemTrackingEvent: .searchPrpOpenDaoFromCard)
                        } else {
                            RetryInitialLoadingView(dataSource: proposals, message: "Sorry, we couldn’t load proposals")
                        }
                    }

                } else {
                    // Searching by text
                    switch model.filter {
                    case .daos:
                        DaosSearchListView(onSelectDao: { dao in
                            activeSheetManager.activeSheet = .daoInfo(dao)
                            Tracker.track(.searchDaosOpenDaoFromSearch)
                        },
                                           onFollowToggle: { didFollow in
                            Tracker.track(.searchDaosFollowFromSearch)
                        })

                    case .proposals:
                        ProposalsSearchResultsListView(dataSource: proposalsSearch, path: $model.path)
                    }
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: true,
                                     navigationTitle: proposal.dao.name)
            }
            .searchable(text: searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .refreshable {
                switch model.filter {
                case .proposals:
                    proposals.refresh()
                case .daos:
                    daos.refresh()
                    RecentlyViewedDaosDataSource.search.refresh()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Search")
                            .font(.title3Semibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }
            }
            .onAppear() {
                daos.refresh()
                RecentlyViewedDaosDataSource.search.refresh()
            }
        }
    }
}
