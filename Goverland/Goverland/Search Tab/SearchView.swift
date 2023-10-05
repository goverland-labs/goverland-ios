//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI


struct SearchView: View {
    @StateObject var model = SearchModel.shared

    @StateObject var daos = GroupedDaosDataSource()
    @StateObject var proposals = TopProposalDataSource()
    @StateObject var proposalsSearch = ProposalsSearchResultsDataSource()


    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    private var searchPrompt: String {
        switch model.filter {
        case .daos:
            if let total = daos.totalDaos.map(String.init) {
                return "Search for \(total) DAOs by name"
            }
            return ""
        case .proposals:
            if let total = proposals.totalProposals.map(String.init) {
                return "Search for \(total) proposals by name"
            }
            return ""
        }
    }

    private var searchText: Binding<String> {
        switch model.filter {
        case .daos:
            return $daos.searchText
        case .proposals:
            return $proposalsSearch.searchText
        }
    }
    
    var body: some View {
        NavigationStack(path: $model.path) {
            VStack {
                FilterButtonsView<SearchFilter>(filter: $model.filter) { _ in }

                if searchText.wrappedValue == "" {
                    switch model.filter {
                    case .daos:
                        ZStack {
                            if !daos.failedToLoadInitialData {
                                GroupedDaosView(dataSource: daos,
                                                onSelectDaoFromGroup: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCard) },
                                                onSelectDaoFromCategoryList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgList) },
                                                onSelectDaoFromCategorySearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgSearch) },

                                                onFollowToggleFromCard: { if $0 { Tracker.track(.searchDaosFollowFromCard) } },
                                                onFollowToggleFromCategoryList: { if $0 { Tracker.track(.searchDaosFollowFromCtgList) } },
                                                onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.searchDaosFollowFromCtgSearch) } },

                                                onCategoryListAppear: { Tracker.track(.screenSearchDaosCtgDaos) })
                            } else {
                                RetryInitialLoadingView(dataSource: daos)
                            }
                        }
                        .onAppear() {
                            Tracker.track(.screenSearchDaos)
                        }
                    case .proposals:
                        if !proposals.failedToLoadInitialData {
                            TopProposalsListView(dataSource: proposals, path: $model.path)
                        } else {
                            RetryInitialLoadingView(dataSource: proposals)
                        }
                    }

                } else {
                    // Searching by text
                    switch model.filter {
                    case .daos:
                        DaosSearchListView(dataSource: daos,
                                           onSelectDao: { dao in
                            activeSheetManger.activeSheet = .daoInfo(dao)
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
                // TODO: refactor
                daos.refresh()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
