//
//  DashboardPopularDaosListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DashboardPopularDaosHorizontalListView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.popularDaos

    let category: DaoCategory = .popular

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    if dataSource.categoryDaos[category] == nil { // initial loading
                        ForEach(0..<3) { _ in
                            ShimmerView()
                                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        }
                    } else {
                        let count = dataSource.categoryDaos[category]!.count
                        ForEach(0..<count, id: \.self) { index in
                            let dao = dataSource.categoryDaos[category]![index]
                            if index == count - 1 && dataSource.hasMore(category: category) {
                                if !dataSource.failedToLoad(category: category) { // try to paginate
                                    ShimmerView()
                                        .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                        .cornerRadius(Avatar.Size.m.daoImageSize/2)
                                        .onAppear {
                                            dataSource.loadMore(category: category)
                                        }
                                } else {
                                    RefreshIcon {
                                        dataSource.retryLoadMore(category: category)
                                    }
                                }
                            } else {
                                DAORoundViewWithActiveVotes(dao: dao) {
                                    activeSheetManager.activeSheet = .daoInfo(dao)
                                    Tracker.track(.dashPopularDaoOpen)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.container)
            .cornerRadius(20)
            .padding(.horizontal, 8)
        }
    }
}

struct DashboardPopularDaosCardsView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.popularDaos

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            DaoThreadForCategoryView(dataSource: dataSource,
                                     category: DaoCategory.popular,
                                     onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpen) },
                                     onFollowToggle: { if $0 { Tracker.track(.dashPopularDaoFollow) } })
            .padding(.leading, 8)
        }
    }
}
