//
//  FollowDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct FollowDaosListView: View {
    @StateObject private var dataSource = ListFollowedDaosDataSource()

    private var searchPrompt: String {
        if let totalDaos = dataSource.total.map(String.init) {
            return "Search in \(totalDaos)"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                if dataSource.searchText == "" {
                    
                    if !dataSource.failedToLoadInitialData { ListFollowedDaosView(dataSource: dataSource)
                    } else { RetryInitialLoadingView(dataSource: dataSource) }
                    
                } else {} // { DaosSearchListView(dataSource: dataSource) }
                
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
                        Text("Followed DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onAppear() {
                dataSource.refresh()
                //Tracker.track(.selectDaoView)
            }
        }
    }
}

struct FollowDaosListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaosListView()
    }
}
