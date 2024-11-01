//
//  RecentlyViewedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct RecentlyViewedDaosHorizontalListView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @StateObject var dataSource = RecentlyViewedDaosDataSource.search

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if dataSource.recentlyViewedDaos.isEmpty { // initial loading
                        ForEach(0..<5) { _ in
                            ShimmerView()
                                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        }
                    } else {
                        ForEach(dataSource.recentlyViewedDaos) { dao in
                            DAORoundViewWithActiveVotes(dao: dao) {
                                activeSheetManager.activeSheet = .daoInfoById(dao.id.uuidString)
                                Tracker.track(.searchRecentDaoOpen)
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
