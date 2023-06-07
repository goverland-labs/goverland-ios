//
//  FollowDaoGroupView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct FollowDaosView: View {
    @StateObject private var dataSource = GroupDaosDataSource()

    private var searchPrompt: String {
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search \(totalDaos) DAOs by name"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitially {
                        Text("Get Updates for the DAOs you select.")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        prompt: searchPrompt)
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
