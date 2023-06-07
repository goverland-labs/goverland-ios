//
//  SearchView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var dataSource = GroupedDaosDataSource()
    @State private var currentControl: SearchViewControls = .daos
    private let controls: [SearchViewControls] = SearchViewControls.all

    private var searchPrompt: String {
        // TODO: make aware of selected control
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search \(totalDaos) DAOs by name"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: move to a subview
                HStack {
                    ForEach(controls, id: \.self) { control in
                        VStack(spacing: 12) {
                            Text(control.localizedString)
                                .fontWeight(.semibold)
                                .foregroundColor(currentControl == control ? .primary : .gray)
                            Capsule(style: .continuous)
                                .foregroundColor(currentControl == control ? .primaryDim : .clear)
                                .frame(width: 80, height: 2)
                        }
                        .onTapGesture {
                            withAnimation {
                                self.currentControl = control
                            }
                        }
                    }
                }
                .fontWeight(.semibold)
                .padding(.top)
                
                Capsule(style: .continuous)
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.bottom)
                
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitially {
                        switch currentControl {
                        case .daos:
                            GroupedDaosView(dataSource: dataSource)
                        case .proposals:
                            EmptyView()
                                .onAppear { Tracker.track(.searchProposalView) }
                        }
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    //DaosSearchListView(dataSource: dataSource)
                }
            }
            .navigationDestination(for: DaoCategory.self) { category in
                FollowCategoryDaosListView(category: category)
            }
            .padding(.horizontal, 15)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Search DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.selectDaoView)
            }
        }
    }
}
                    

fileprivate enum SearchViewControls {
    case daos, proposals
    
    static var all: [Self] { return [.daos, .proposals] }
    
    var localizedString: String {
        switch self {
        case .daos: return "DAOs"
        case .proposals: return "Proposals"
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
