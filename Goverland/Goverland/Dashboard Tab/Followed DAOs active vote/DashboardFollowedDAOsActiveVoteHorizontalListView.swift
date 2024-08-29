//
//  DashboardFollowedDAOsActiveVoteHorizontalListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DashboardFollowedDAOsActiveVoteHorizontalListView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @ObservedObject var dataSource = FollowedDAOsActiveVoteDataSource.dashboard

    var body: some View {
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
                                Tracker.track(.dashFollowedDaoActiveVoteOpenDao)
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
