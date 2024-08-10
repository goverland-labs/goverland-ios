//
//  PublicUserProfileDaosListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.04.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileDaosListView: View {
    @StateObject private var dataSource: PublicUserProfileDaosDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(profileId: String) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileDaosDataSource(profileId: profileId))
    }

    var body: some View {
        Group {
            if dataSource.isLoading {
                VStack(spacing: 12) {
                    ForEach(0..<7, id: \.self) { _ in
                        ShimmerDaoListItemView()
                    }
                    Spacer()
                }
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAOs list")
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(dataSource.daos) { dao in
                            EmptyView()
                            DaoListItemView(
                                dao: dao,
                                subscriptionMeta: dao.subscriptionMeta,
                                onSelectDao: { dao in
                                    activeSheetManager.activeSheet = .daoInfo(dao)
                                    Tracker.track(.publicPrfDaoFullOpenDao)
                                },
                                onFollowToggle: { didFollow in
                                    Tracker.track(didFollow ? .publicPrfDaoFullFollow : .publicPrfDaoFullUnfollow)
                                }
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Voted in DAOs")
        .onAppear() {
            if dataSource.daos.isEmpty {
                dataSource.refresh()
            }
            Tracker.track(.screenPublicPrfDaoFull)
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheetManager.activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}
