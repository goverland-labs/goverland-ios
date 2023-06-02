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

    init(category: DaoCategory) {
        title = "\(category.name) DAOs"
        _dataSource = StateObject(wrappedValue: CategoryDaosDataSource(category: category))
    }

    var body: some View {
        DaosListView(dataSource: dataSource)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .onAppear {
                Tracker.track(.followCategoryDaosView)
                dataSource.refresh()
            }
    }
}

fileprivate struct DaosListView: View {
    @ObservedObject var dataSource: CategoryDaosDataSource

    var body: some View {
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
                                    RetryLoadMoreView(dataSource: dataSource)
                                }
                            } else {
                                FollowDaoListItemView(dao: dataSource.daos[index])
                            }
                        }
                    }
                }
            }
        } else {
            RetryInitialLoadingView(dataSource: dataSource)
        }
    }
}

// TODO: implement design
fileprivate struct RetryLoadMoreView: View {
    let dataSource: CategoryDaosDataSource

    var body: some View {
        Button("Load more") {
            dataSource.retryLoadMore()
        }
    }
}

struct FollowDaoListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowCategoryDaosListView(category: .social)
    }
}
