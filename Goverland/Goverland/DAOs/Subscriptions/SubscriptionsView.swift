//
//  SubscriptionsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-17.
//

import SwiftUI

struct SubscriptionsView: View {
    @StateObject private var dataSource = SubscriptionsDataSource()
    @State private var showFollowDaos = false
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
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
                            NoSubscriptionsView(showFollowDaos: $showFollowDaos)
                        } else {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 12) {
                                    ForEach(dataSource.subscriptions) { subscription in
                                        DaoListItemView(
                                            dao: subscription.dao,
                                            subscriptionMeta: SubscriptionMeta(id: subscription.id,
                                                                               createdAt: subscription.createdAt),
                                            onDaoImageTap: {
                                                navPath.append(subscription.dao.id)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: UUID.self) { daoId in
                // TODO: Navigation to DaoInfoView (after merging Andrey's open PR)
                AddSubscriptionView()
            }
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Followed DAOs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFollowDaos = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showFollowDaos, content: {
                NavigationStack {
                    AddSubscriptionView()
                }
            })
            .refreshable {
                dataSource.refresh()
            }
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.followedDaosListView)
            }
            .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { _ in
                if showFollowDaos {
                    dataSource.refresh()
                }
            }
        }
    }
}

fileprivate struct NoSubscriptionsView: View {
    @Binding var showFollowDaos: Bool

    var body: some View {
        VStack {
            Text("You don’t follow any DAO at the moment.")
                .padding(.bottom, 50)
            Button(action: { showFollowDaos = true }) {
                Text("Follow a DAO")
                    .ghostActionButtonStyle()
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
