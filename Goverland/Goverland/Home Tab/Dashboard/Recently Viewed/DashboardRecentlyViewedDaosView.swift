//
//  DashboardRecentlyViewedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-27.
//

import SwiftUI

struct DashboardRecentlyViewedDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @StateObject var dataSource = RecentlyViewedDaosDataSource.dashboard

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if !dataSource.failedToLoadInitialData {
                HStack(spacing: 20) {
                    if dataSource.recentlyViewedDaos.isEmpty { // initial loading
                        ForEach(0..<5) { _ in
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
                .padding()
            } else {
                RetryInitialLoadingView(dataSource: dataSource)
            }
        }
        .background(Color.container)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
