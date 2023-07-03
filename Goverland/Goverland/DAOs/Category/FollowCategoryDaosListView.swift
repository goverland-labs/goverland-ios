//
//  FollowDaoListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import SwiftUI

struct FollowCategoryDaosListView: View {
    @StateObject var dataSource: CategoryDaosDataSource
    let title: String
    let onFollowToggleFromList: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)?
    
    private var searchPrompt: String {
        if let totalForCategory = dataSource.total.map(String.init) {
            return "Search \(totalForCategory) DAOs by name"
        }
        return ""
    }

    init(category: DaoCategory,
         onFollowToggleFromList: ((_ didFollow: Bool) -> Void)? = nil,
         onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)? = nil) {
        title = "\(category.name) DAOs"
        _dataSource = StateObject(wrappedValue: CategoryDaosDataSource(category: category))
        self.onFollowToggleFromList = onFollowToggleFromList
        self.onFollowToggleFromSearch = onFollowToggleFromSearch
    }

    var body: some View {
        DaosListView(dataSource: dataSource,
                     onFollowToggleFromList: onFollowToggleFromList,
                     onFollowToggleFromSearch: onFollowToggleFromSearch)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .onAppear {
                Tracker.track(.followCategoryDaosView)
                dataSource.refresh()
            }
    }
}

fileprivate struct DaosListView: View {
    @ObservedObject var dataSource: CategoryDaosDataSource
    let onFollowToggleFromList: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)?

    var body: some View {
        if dataSource.searchText == "" {
            if !dataSource.failedToLoadInitialData {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if dataSource.daos.isEmpty { // initial loading
                            ForEach(0..<3) { _ in
                                ShimmerDaoListItemView()
                            }
                        } else {
                            ForEach(0..<dataSource.daos.count, id: \.self) { index in
                                if index == dataSource.daos.count - 1 && dataSource.hasMore() {
                                    if !dataSource.failedToLoadMore { // try to paginate
                                        ShimmerDaoListItemView()
                                            .onAppear {
                                                dataSource.loadMore()
                                            }
                                    } else { // retry pagination
                                        RetryLoadMoreListItemView(dataSource: dataSource)
                                    }
                                } else {
                                    let dao = dataSource.daos[index]
                                    DaoListItemView(dao: dao,
                                                    subscriptionMeta: dao.subscriptionMeta,
                                                    onFollowToggle: onFollowToggleFromList)
                                }
                            }
                        }
                    }
                }
            } else {
                RetryInitialLoadingView(dataSource: dataSource)
            }
        } else {
            CategoryDaosSearchListView(dataSource: dataSource, onFollowToggle: onFollowToggleFromSearch)
        }
    }
}

/// Mimics DaosSearchListView, intentionally separate to avoid inheritance issues.
/// Protocols aren't suitable for this case.
fileprivate struct CategoryDaosSearchListView: View {
    @ObservedObject var dataSource: CategoryDaosDataSource
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

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
                        DaoListItemView(dao: dao, subscriptionMeta: dao.subscriptionMeta, onFollowToggle: onFollowToggle)
                    }
                }
            }
        }
    }
}

struct FollowDaoListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowCategoryDaosListView(category: .social)
    }
}
