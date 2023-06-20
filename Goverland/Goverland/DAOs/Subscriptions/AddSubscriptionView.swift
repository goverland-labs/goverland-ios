//
//  AddSubscriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.06.23.
//

import SwiftUI

struct AddSubscriptionView: View {
    @StateObject private var dataSource = GroupedDaosDataSource()

    private var searchPrompt: String {
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search DAOs by name"
        }
        return ""
    }

    var body: some View {
        NavigationStack {
            if dataSource.searchText == "" {
                if !dataSource.failedToLoadInitially {
                    GroupedDaosView(dataSource: dataSource)
                } else {
                    RetryInitialLoadingView(dataSource: dataSource)
                }
            } else {
                DaosSearchListView(dataSource: dataSource)
            }
        }
        .navigationTitle("Follow DAOs")
        // TODO: add Close button to the left
        .navigationDestination(for: DaoCategory.self) { category in
            FollowCategoryDaosListView(category: category)
        }
        .searchable(text: $dataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .onAppear() {
            dataSource.refresh()
            // TODO: add tracking
        }
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
