//
//  FollowedDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct FollowedDaosListView: View {
    @StateObject private var dataSource = FollowedDaosDataSource()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                if !dataSource.failedToLoadInitialData {
                    if dataSource.daos.isEmpty {
                        EmptyView()
                            .onAppear() {
                                ErrorViewModel.shared.setErrorMessage("You don’t follow any DAO at the moment.")
                            }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                               ForEach(dataSource.daos) { dao in
                                   DaoListItemView(dao: dao)
                               }
                            }
                        }
                    }
                } else {
                    RetryInitialLoadingView(dataSource: dataSource)
                }
            }
            .padding(.horizontal, 15)
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
                Tracker.track(.followedDaosListView)
            }
        }
    }
}

struct FollowDaosListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowedDaosListView()
    }
}
