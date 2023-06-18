//
//  FollowDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct FollowDaosListView: View {
    @StateObject private var dataSource = FollowedDaosDataSource()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitialData {
                        FollowedDaosView(dataSource: dataSource)
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    FollowedDaosSearchListView(dataSource: dataSource)
                }
            }
            .padding(.horizontal, 15)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "")
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
                Tracker.track(.followListDaoView)
            }
        }
    }
}

private struct FollowedDaosSearchListView: View {
    @ObservedObject var dataSource: FollowedDaosDataSource

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Nothing found")
                } else if dataSource.searchResultDaos.isEmpty { // initial searching
                    ForEach(0..<3) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDaos) { dao in
                        DaoListItemView(dao: dao)
                    }
                }
            }
        }
    }
}

struct FollowDaosListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaosListView()
    }
}
