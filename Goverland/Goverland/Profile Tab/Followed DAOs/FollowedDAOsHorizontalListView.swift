//
//  FollowedDAOsHorizontalListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 03.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct FollowedDAOsHorizontalListView: View {
    @StateObject private var dataSource = FollowedDaosDataSource.horizontalList
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        if dataSource.isLoading { // initial loading
                            ForEach(0..<5) { _ in
                                ShimmerView()
                                    .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                    .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                            }
                        } else {
                            ForEach(dataSource.subscriptions) { subscription in
                                DAORoundViewWithActiveVotes(dao: subscription.dao) {
                                    activeSheetManager.activeSheet = .daoInfoById(subscription.dao.id.uuidString)
                                    Tracker.track(.dashPopularDaoOpen)
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
        .onAppear() {
            if dataSource.subscriptions.isEmpty {
                dataSource.refresh()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // always refresh
            dataSource.refresh()
        }
    }
}
