//
//  FollowedDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct FollowedDaosView: View {
    @StateObject private var dataSource = FollowedDaosDataSource.followedDaos
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.isLoading {
                VStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        ShimmerDaoListItemView()
                    }
                    Spacer()
                }
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAOs list")
            } else if dataSource.subscriptions.isEmpty {
                NoSubscriptionsView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(dataSource.subscriptions) { subscription in
                            DaoListItemView(
                                dao: subscription.dao,
                                subscriptionMeta: SubscriptionMeta(id: subscription.id, createdAt: subscription.createdAt),
                                onSelectDao: { dao in
                                    activeSheetManager.activeSheet = .daoInfo(subscription.dao)
                                    Tracker.track(.followedDaosOpenDao)
                                },
                                onFollowToggle: { didFollow in
                                    Tracker.track(didFollow ? .followedDaosRefollow : .followedDaosUnfollow)
                                }
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Followed DAOs")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    activeSheetManager.activeSheet = .followDaos
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .refreshable {
            dataSource.refresh()
        }
        .onAppear() {
            dataSource.refresh()            
            Tracker.track(.screenFollowedDaos)
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheetManager.activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct NoSubscriptionsView: View {
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                Image("looped-line")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width / 2)
                Text("You don't follow any DAOs at the moment.")
                    .font(.callout)
                    .foregroundColor(.textWhite)
                Spacer()
                PrimaryButton("Explore DAOs") {
                    activeSheetManager.activeSheet = .followDaos
                }
                Spacer()
            }
            // this is needed as on iPad GeometryReader breaks VStack layout
            .frame(width: geometry.size.width - 32)
            .padding([.horizontal, .bottom], 16)
            .onAppear {
                Tracker.track(.screenFollowedDaosEmpty)
            }
        }
    }
}
