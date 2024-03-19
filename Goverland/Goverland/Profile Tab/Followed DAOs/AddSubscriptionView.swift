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
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications

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
                                    onSelectDaoFromGroup: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCard) },
                                    onSelectDaoFromCategoryList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgList) },
                                    onSelectDaoFromCategorySearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgSearch) },

                                    onFollowToggleFromCard: { didFollow, _ in if didFollow { Tracker.track(.followedAddFollowFromCard) } },
                                    onFollowToggleFromCategoryList: { didFollow, _ in if didFollow { Tracker.track(.followedAddFollowFromCtgList) } },
                                    onFollowToggleFromCategorySearch: { didFollow, _ in if didFollow { Tracker.track(.followedAddFollowFromCtgSearch) } },

                                    onCategoryListAppear: { Tracker.track(.screenFollowedAddCtg) })
                } else {
                    RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAOs list")
                }
            } else {
                DaosSearchListView(onSelectDao: { dao in
                    activeSheetManager.activeSheet = .daoInfo(dao)
                    Tracker.track(.followedAddOpenDaoFromSearch)
                },
                                   onFollowToggle: { didFollow, _ in
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

            ToolbarTitle("Explore DAOs")            
        }
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.screenFollowedDaosAdd)
        }
        .onChange(of: lastAttemptToPromotedPushNotifications) { _, _ in
            showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
        }
    }
}
