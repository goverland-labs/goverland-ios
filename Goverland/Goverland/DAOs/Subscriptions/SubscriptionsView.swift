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
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                if dataSource.isLoading {
                    VStack {
                        ShimmerDaoListItemView()
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
                                    // TODO: Navigation to DaoInfoScreenView
                                    ForEach(dataSource.subscriptions) { subscription in
                                        DaoListItemView(
                                            dao: subscription.dao,
                                            subscriptionMeta: SubscriptionMeta(id: subscription.id,
                                                                               createdAt: subscription.createdAt))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Followed DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .sheet(isPresented: $showFollowDaos, onDismiss: {
                dataSource.refresh()
                showFollowDaos = false
            }, content: {
                AddSubscriptionView()
            })
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.followedDaosListView)
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
                Text("Follow DAO")
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
