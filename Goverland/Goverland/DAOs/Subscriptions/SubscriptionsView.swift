//
//  SubscriptionsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct SubscriptionsView: View {
    @StateObject private var dataSource = SubscriptionsDataSource()

    @Binding var activeSheet: SettingsActiveSheet?

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
                        NoSubscriptionsView(activeSheet: $activeSheet)
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(dataSource.subscriptions) { subscription in
                                    DaoListItemView(
                                        dao: subscription.dao,
                                        subscriptionMeta: SubscriptionMeta(id: subscription.id,
                                                                           createdAt: subscription.createdAt)
                                    )
                                    .onTapGesture {
                                        NotificationCenter.default.post(name: .didSelectShowDaoInfo, object: subscription.dao)
                                    }
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
                    activeSheet = .followDaos
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
            Tracker.track(.followedDaosListView)
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
            // refresh if some popover sheet is presented
            if activeSheet != nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct NoSubscriptionsView: View {
    @Binding var activeSheet: SettingsActiveSheet?
    
    var body: some View {
        VStack {
            Text("You don’t follow any DAO at the moment.")
                .padding(.bottom, 50)
            Button(action: {
                activeSheet = .followDaos
            }) {
                Text("Follow a DAO")
                    .ghostActionButtonStyle()
            }
        }
        .padding()
    }
}

struct FollowDaosListView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView(activeSheet: .constant(nil))
    }
}
