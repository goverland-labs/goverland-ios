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
    @StateObject private var dataSource = GroupedDaosDataSource()

    private var searchPrompt: String {
        switch filter {
        case .daos:
            if let total = dataSource.totalDaos.map(String.init) {
                return "Search for \(total) DAOs by name"
            }
            return ""
        case .proposals:
            return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                FilterButtonsView<SearchFilter>(filter: $filter) { newValue in
                    switch newValue {
                    case .daos: dataSource.refresh()
                    case .proposals: break
                    }
                }
                .padding(.bottom, 4)
                
                if dataSource.searchText == "" {
                    switch filter {
                    case .daos:
                        if !dataSource.failedToLoadInitially {
                            GroupedDaosView(dataSource: dataSource,
                                            onFollowToggleFromCard: { if $0 { Tracker.track(.searchDaosFollowFromCard) } },
                                            onCategoryListAppear: { Tracker.track(.screenSearchDaosCtgDaos) },
                                            onFollowToggleFromCategoryList: { if $0 { Tracker.track(.searchDaosFollowFromCtgList) } },
                                            onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.searchDaosFollowFromCtgSearch) } })
                        } else {
                            RetryInitialLoadingView(dataSource: dataSource)
                        }
                    case .proposals:
                        SearchProposalView()
                    }

                } else {
                    switch filter {
                    case .daos: DaosSearchListView(dataSource: dataSource, onFollowToggle: { didFollow in
                        Tracker.track(.searchDaosFollowFromSearch)
                    })
                    case .proposals: SearchProposalView()
                    }
                }
            }
            .searchable(text: $dataSource.searchText,
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
                dataSource.refresh()
                Tracker.track(.screenSearchDaos)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
