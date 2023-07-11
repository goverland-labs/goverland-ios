//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

enum SearchFilter: Int, FilterOptions {
    case daos = 0
    case proposals

    var localizedName: String {
        switch self {
        case .daos:
            return "Daos"
        case .proposals:
            return "Proposals"
        }
    }
}

struct SearchView: View {
    @State private var filter: SearchFilter = .daos
    @State private var path = NavigationPath()

    @StateObject private var daoDataSource = GroupedDaosDataSource()
    @StateObject private var proposalDataSource = ProposalDataSource()
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    private var searchPrompt: String {
        switch filter {
        case .daos:
            if let total = daoDataSource.totalDaos.map(String.init) {
                return "Search for \(total) DAOs by name"
            }
            return ""
        case .proposals:
            if let total = proposalDataSource.totalProposals.map(String.init) {
                return "Search for \(total) proposals by name"
            }
            return ""
        }
    }

    private var searchText: Binding<String> {
        switch filter {
        case .daos:
            return $daoDataSource.searchText
        case .proposals:
            return $proposalDataSource.searchText
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                FilterButtonsView<SearchFilter>(filter: $filter) { newValue in
                    switch newValue {
                    case .daos: break
                    case .proposals: break
                    }
                }
                .padding(.bottom, 4)
                
                if searchText.wrappedValue == "" {
                    switch filter {
                    case .daos:
                        ZStack {
                            if !daoDataSource.failedToLoadInitially {
                                GroupedDaosView(dataSource: daoDataSource,
                                                onSelectDaoFromGroup: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCard) },
                                                onSelectDaoFromCategoryList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgList) },
                                                onSelectDaoFromCategorySearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.searchDaosOpenDaoFromCtgSearch) },

                                                onFollowToggleFromCard: { if $0 { Tracker.track(.searchDaosFollowFromCard) } },
                                                onFollowToggleFromCategoryList: { if $0 { Tracker.track(.searchDaosFollowFromCtgList) } },
                                                onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.searchDaosFollowFromCtgSearch) } },

                                                onCategoryListAppear: { Tracker.track(.screenSearchDaosCtgDaos) })
                            } else {
                                RetryInitialLoadingView(dataSource: daoDataSource)
                            }
                        }
                        .onAppear() {
                            Tracker.track(.screenSearchDaos)
                        }
                    case .proposals:
                        if !proposalDataSource.failedToLoadInitialData {
                            ProposalsListView(dataSource: proposalDataSource, path: $path)
                        } else {
                            RetryInitialLoadingView(dataSource: proposalDataSource)
                        }
                    }

                } else {
                    // Searching by text
                    switch filter {
                        
                    case .daos:
                        DaosSearchListView(dataSource: daoDataSource,
                                           onSelectDao: { dao in
                            activeSheetManger.activeSheet = .daoInfo(dao)
                            Tracker.track(.searchDaosOpenDaoFromSearch)
                        },
                                           onFollowToggle: { didFollow in
                            Tracker.track(.searchDaosFollowFromSearch)
                        })

                    case .proposals:
                        ProposalsListView(dataSource: proposalDataSource, path: $path)
                    }
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal, allowShowingDaoInfo: true, navigationTitle: proposal.dao.name)
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
                daoDataSource.refresh()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
