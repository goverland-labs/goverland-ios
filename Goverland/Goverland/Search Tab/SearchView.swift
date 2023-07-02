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
        // TODO: make aware of selected control
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search \(filter.localizedName) by name"
        }
        return ""
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
                    if !dataSource.failedToLoadInitially {
                        switch filter {
                        case .daos:
                            GroupedDaosView(dataSource: dataSource)
                        case .proposals:
                            SearchProposalView()
                        }
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    DaosSearchListView(dataSource: dataSource)
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
                Tracker.track(.searchDaos)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
