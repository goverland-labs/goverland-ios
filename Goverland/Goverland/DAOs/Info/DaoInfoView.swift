//
//  DaoInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

enum DaoInfoFilter: Int, FilterOptions {
    case activity = 0
    case insights
    case about

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .insights:
            return "Insights"
        case .about:
            return "About"
        }
    }
}

struct DaoInfoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var dataSource: DaoInfoDataSource
    @State private var filter: DaoInfoFilter = .activity
    @Setting(\.lastPromotedPushNotificationsTime) private var lastPromotedPushNotificationsTime
    @Setting(\.notificationsEnabled) private var notificationsEnabled

    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManager = ActiveSheetManager()

    var dao: Dao? { dataSource.dao }

    init(daoID: UUID) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(daoID: daoID))
    }

    init(dao: Dao) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(dao: dao))
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                // Unfortunately shimmer or reducted view here breaks presentation in a popover view
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else if let dao = dao {
                VStack(spacing: 0) {
                    DaoInfoScreenHeaderView(dao: dao)
                        .padding(.horizontal)
                        .padding(.bottom)

                    FilterButtonsView<DaoInfoFilter>(filter: $filter) { _ in }
                    
                    switch filter {
                    case .activity: DaoInfoEventsView(dao: dao)
                    case .about: DaoInfoAboutDaoView(dao: dao)
                    case .insights: DaoInsightsView(dao: dao, activeSheetManager: activeSheetManager)
                    }
                }
            }
        }
        .navigationTitle(dataSource.dao?.name ?? "DAO")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            if let dao = dao {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        DaoSharingMenu(dao: dao)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .signIn:
                SignInView()
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
            if now - lastPromotedPushNotificationsTime > 60 * 60 * 24 * 60 && !notificationsEnabled {
                // don't promore if some active sheet already displayed
                if activeSheetManager.activeSheet == nil {
                    lastPromotedPushNotificationsTime = now
                    activeSheetManager.activeSheet = .subscribeToNotifications
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
            // This approach is used on AppTabView and DaoInfoView
            if activeSheetManager.activeSheet == nil {
                activeSheetManager.activeSheet = .signIn
            }
        }
    }
}
