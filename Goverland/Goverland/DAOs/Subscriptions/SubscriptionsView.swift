//
//  SubscriptionsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct SubscriptionsView: View {
    @StateObject private var dataSource = SubscriptionsDataSource()
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if dataSource.isLoading {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        ShimmerDaoListItemView()
                    }
                    Spacer()
                }
            } else {
                if dataSource.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: dataSource)
                } else {
                    if dataSource.subscriptions.isEmpty {
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
        VStack(spacing: 40) {
            Image("settings-follow-dao-background")
            Text("You don’t follow any DAO at the moment.")
            PrimaryButton("Follow a DAO") {
                activeSheetManager.activeSheet = .followDaos
            }
        }
        .padding()
    }
}

struct FollowDaosListView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView()
    }
}
