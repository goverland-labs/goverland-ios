//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct SearchView: View {
    @State private var path = NavigationPath()
    @StateObject private var data = SearchViewDataSource.shared
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    private var searchPrompt: String {
        switch data.filter {
        case .daos:
            if let total = data.daos.totalDaos.map(String.init) {
                return "Search for \(total) DAOs by name"
            }
            return ""
        case .proposals:
            if let total = data.proposals.totalProposals.map(String.init) {
                return "Search for \(total) proposals by name"
            }
            return ""
        }
    }

    private var searchText: Binding<String> {
        switch data.filter {
        case .daos:
            return $data.daos.searchText
        case .proposals:
            return $data.proposalsSearch.searchText
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                FilterButtonsView<SearchFilter>(filter: $data.filter) { _ in }

                if searchText.wrappedValue == "" {
                    switch data.filter {
                    case .daos:
                        ZStack {
                            if !data.daos.failedToLoadInitialData {
                                GroupedDaosView(dataSource: data.daos,
                                                onSelectDaoFromGroup: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCard) },
                                                onSelectDaoFromCategoryList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgList) },
                                                onSelectDaoFromCategorySearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgSearch) },

                                                onFollowToggleFromCard: { if $0 { Tracker.track(.searchDaosFollowFromCard) } },
                                                onFollowToggleFromCategoryList: { if $0 { Tracker.track(.searchDaosFollowFromCtgList) } },
                                                onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.searchDaosFollowFromCtgSearch) } },

                                                onCategoryListAppear: { Tracker.track(.screenSearchDaosCtgDaos) })
                            } else {
                                RetryInitialLoadingView(dataSource: data.daos)
                            }
                        }
                        .onAppear() {
                            Tracker.track(.screenSearchDaos)
                        }
                    case .proposals:
                        if !data.proposals.failedToLoadInitialData {
                            TopProposalsListView(dataSource: data.proposals, path: $path)
                        } else {
                            RetryInitialLoadingView(dataSource: data.proposals)
                        }
                    }

                } else {
                    // Searching by text
                    switch data.filter {
                    case .daos:
                        DaosSearchListView(dataSource: data.daos,
                                           onSelectDao: { dao in
                            activeSheetManger.activeSheet = .daoInfo(dao)
                            Tracker.track(.searchDaosOpenDaoFromSearch)
                        },
                                           onFollowToggle: { didFollow in
                            Tracker.track(.searchDaosFollowFromSearch)
                        })

                    case .proposals:
                        ProposalsSearchResultsListView(dataSource: data.proposalsSearch, path: $path)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Search")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear() {
                data.daos.refresh()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
