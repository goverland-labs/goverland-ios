//
//  DashboardRecentlyViewedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DashboardRecentlyViewedDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @StateObject var dataSource = RecentlyViewedDaosDataSource.dashboard

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if dataSource.recentlyViewedDaos.isEmpty { // initial loading
                        ForEach(0..<3) { _ in
                            ShimmerView()
                                .frame(width: 45, height: 45)
                                .cornerRadius(45 / 2)
                        }
                    } else {
                        ForEach(dataSource.recentlyViewedDaos) { dao in
                            RoundPictureView(image: dao.avatar, imageSize: 45)
                                .onTapGesture {
                                    activeSheetManger.activeSheet = .daoInfo(dao)
                                    Tracker.track(.dashRecentDaoOpen)
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
