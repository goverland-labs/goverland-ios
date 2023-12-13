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
    @Setting(\.lastPromotedPushNotificationsTime) private var lastPromotedPushNotificationsTime
    @Setting(\.notificationsEnabled) private var notificationsEnabled

    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManager = ActiveSheetManager()

    private var searchPrompt: String {
        if let total = dataSource.totalDaos.map(String.init) {
            return "Search for \(total) DAOs by name"
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
                        .foregroundColor(.textWhite)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Explore DAOs")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.screenFollowedDaosAdd)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .daoInfo(let dao):
                NavigationStack {
                    DaoInfoView(dao: dao)
                }
                .accentColor(.textWhite)
                .overlay {
                    ToastView()
                }
            case .subscribeToNotifications:
                EnablePushNotificationsView()
            default:
                // should not happen
                EmptyView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { notification in
            // This approach is used on AppTabView, DaoInfoView and AddSubscriptionView
            guard let subscribed = notification.object as? Bool, subscribed else { return }
            // A user followed a DAO. Offer to subscribe to Push Notifications every two months if a user is not subscribed.
            let now = Date().timeIntervalSinceReferenceDate
            if now - lastPromotedPushNotificationsTime > ConfigurationManager.enablePushNotificationsRequestInterval && !notificationsEnabled {
                // don't promore if some active sheet already displayed
                if activeSheetManager.activeSheet == nil {
                    lastPromotedPushNotificationsTime = now
                    activeSheetManager.activeSheet = .subscribeToNotifications
                }
            }
        }
    }
}
