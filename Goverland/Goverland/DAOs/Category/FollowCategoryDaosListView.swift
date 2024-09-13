//
//  FollowDaoListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct FollowCategoryDaosListView: View {
    @StateObject var dataSource: CategoryDaosDataSource
    let title: String

    let onSelectDaoFromList: ((Dao) -> Void)?
    let onSelectDaoFromSearch: ((Dao) -> Void)?

    let onFollowToggleFromList: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)?

    let onCategoryListAppear: (() -> Void)?

    private var searchPrompt: String {
        if let total = dataSource.total {
            let totalStr = Utils.formattedNumber(Double(total))
            return "Search \(totalStr) DAOs by name"
        }
        return ""
    }

    init(category: DaoCategory,

         onSelectDaoFromList: ((Dao) -> Void)? = nil,
         onSelectDaoFromSearch: ((Dao) -> Void)? = nil,

         onFollowToggleFromList: ((_ didFollow: Bool) -> Void)? = nil,
         onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)? = nil,

         onCategoryListAppear: (() -> Void)? = nil
    ) {
        title = "\(category.name) DAOs"
        _dataSource = StateObject(wrappedValue: CategoryDaosDataSource(category: category))

        self.onSelectDaoFromList = onSelectDaoFromList
        self.onSelectDaoFromSearch = onSelectDaoFromSearch

        self.onFollowToggleFromList = onFollowToggleFromList
        self.onFollowToggleFromSearch = onFollowToggleFromSearch

        self.onCategoryListAppear = onCategoryListAppear
    }

    var body: some View {
        _DaosListView(dataSource: dataSource,
                      onSelectDaoFromList: onSelectDaoFromList,
                      onSelectDaoFromSearch: onSelectDaoFromSearch,
                      onFollowToggleFromList: onFollowToggleFromList,
                      onFollowToggleFromSearch: onFollowToggleFromSearch)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
        .searchable(text: $dataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .onAppear {
            dataSource.refresh()
            onCategoryListAppear?()
        }
    }
}

fileprivate struct _DaosListView: View {
    @ObservedObject var dataSource: CategoryDaosDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    let onSelectDaoFromList: ((Dao) -> Void)?
    let onSelectDaoFromSearch: ((Dao) -> Void)?

    let onFollowToggleFromList: ((_ didFollow: Bool) -> Void)?
    let onFollowToggleFromSearch: ((_ didFollow: Bool) -> Void)?

    var body: some View {
        Group {
            if dataSource.searchText == "" {
                if !dataSource.failedToLoadInitialData {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            if dataSource.isLoading {
                                ForEach(0..<7) { _ in
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
                                        if index < dataSource.daos.count {
                                            // We caught `Index out of range` crashes. It should not happen, but as dataSource
                                            // is shared, could happen in some case.
                                            let dao = dataSource.daos[index]
                                            DaoListItemView(dao: dao,
                                                            subscriptionMeta: dao.subscriptionMeta,
                                                            onSelectDao: onSelectDaoFromList,
                                                            onFollowToggle: onFollowToggleFromList)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAOs list")
                }
            } else {
                _CategoryDaosSearchListView(dataSource: dataSource,
                                            onSelectDao: onSelectDaoFromSearch,
                                            onFollowToggle: onFollowToggleFromSearch)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheetManager.activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}

/// Mimics DaosSearchListView, intentionally separate to avoid inheritance issues.
/// Protocols aren't suitable for this case.
fileprivate struct _CategoryDaosSearchListView: View {
    @ObservedObject var dataSource: CategoryDaosDataSource
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if dataSource.nothingFound {
                    Text("Nothing found")
                        .font(.body)
                        .foregroundStyle(Color.textWhite)
                        .padding(.top, 16)
                } else if dataSource.searchResultDaos.isEmpty { // initial searching
                    ForEach(0..<7) { _ in
                        ShimmerDaoListItemView()
                    }
                } else {
                    ForEach(dataSource.searchResultDaos) { dao in
                        DaoListItemView(dao: dao,
                                        subscriptionMeta: dao.subscriptionMeta,
                                        onSelectDao: onSelectDao,
                                        onFollowToggle: onFollowToggle)
                    }
                }
            }
        }
    }
}
