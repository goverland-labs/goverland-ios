//
//  AddSubscriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

/// This view is always presented in a popover
struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataSource = GroupedDaosDataSource.addSubscription
    @StateObject private var searchDataSource = DaosSearchDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Setting(\.authToken) private var authToken

    private var searchPrompt: String {
        if let total = dataSource.totalDaos {
            let totalStr = Utils.formattedNumber(Double(total))
            return "Search for \(totalStr) DAOs by name"
        }
        return ""
    }

    var body: some View {
        VStack {
            if searchDataSource.searchText == "" {
                if !dataSource.failedToLoadInitialData {
                    GroupedDaosView(dataSource: dataSource,
                                    activeSheetManager: activeSheetManager,
                                    onSelectDaoFromGroup: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCard) },
                                    onSelectDaoFromCategoryList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgList) },
                                    onSelectDaoFromCategorySearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgSearch) },

                                    onFollowToggleFromCard: { if $0 { Tracker.track(.followedAddFollowFromCard) } },
                                    onFollowToggleFromCategoryList: { if $0 { Tracker.track(.followedAddFollowFromCtgList) } },
                                    onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.followedAddFollowFromCtgSearch) } },

                                    onCategoryListAppear: { Tracker.track(.screenFollowedAddCtg) })
                } else {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAOs list")
                }
            } else {
                DaosSearchListView(onSelectDao: { dao in
                    activeSheetManager.activeSheet = .daoInfo(dao)
                    Tracker.track(.followedAddOpenDaoFromSearch)
                },
                                   onFollowToggle: { didFollow in
                    if didFollow {
                        Tracker.track(.followedAddFollowFromSearch)
                    }
                })
            }
        }
        .searchable(text: $searchDataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.textWhite)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Explore DAOs")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
        }
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.screenFollowedDaosAdd)
        }        
        // This approach is used on AppTabView, DaoInfoView and AddSubscriptionView
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { notification in
            guard let subscribed = notification.object as? Bool, subscribed else { return }
            // A user followed a DAO. Offer to subscribe to Push Notifications every two months if a user is not subscribed.
            showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
        }
        .onChange(of: authToken) { _, token in
            if !token.isEmpty {
                showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
            }
        }
    }
}
