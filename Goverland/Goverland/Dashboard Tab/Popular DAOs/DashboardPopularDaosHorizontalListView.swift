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
    @ObservedObject var dataSource = GroupedDaosDataSource.dashboard

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
                        ForEach(0..<5) { _ in
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
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }
}

struct DashboardPopularDaosCardsView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.dashboard

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            DaoThreadForCategoryView(dataSource: dataSource,
                                     category: DaoCategory.popular,
                                     onSelectDao: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.dashPopularDaoOpen) },
                                     onFollowToggle: { didFollow in if didFollow { Tracker.track(.dashPopularDaoFollow) } })
            .padding(.leading, Constants.horizontalPadding)
        }
    }
}
