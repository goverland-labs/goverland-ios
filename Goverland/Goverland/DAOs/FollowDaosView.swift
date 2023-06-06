//
//  FollowDaoGroupView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct FollowDaosView: View {
    @StateObject private var dataSource = GroupDaosDataSource()
    
    var body: some View {
        NavigationStack {
            VStack {
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitially {
                        DaosGroupedByCategoryView(dataSource: dataSource)
                        NavigationLink {
                            EnablePushNotificationsView()
                        } label: {
                            // TODO: make button disabled logic
                            Text("Continue")
                                .ghostActionButtonStyle()
                                .padding(.vertical)
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
                        // TODO: make dao/top return total count of DAOs
                        prompt: "Search 6032 DAOs by name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Select DAOs")
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

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        FollowDaosView()
    }
}
