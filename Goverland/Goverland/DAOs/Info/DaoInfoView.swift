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
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataSource: DaoInfoDataSource
    @State private var filter: DaoInfoFilter = .activity
    @Setting(\.authToken) private var authToken

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
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the DAO information")
            } else if let dao {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }

            ToolbarItem(placement: .principal) {
                HStack {
                    Text(dao?.name ?? "DAO")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)

                    if dao?.verified ?? false {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.textWhite)
                    }
                }
            }

            if let dao = dao {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        DaoSharingMenu(dao: dao)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .signIn:
                SignInView(source: .popover)
            case .daoInfo(let dao):
                NavigationStack {
                    DaoInfoView(dao: dao)
                }
                .tint(.textWhite)
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
        .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
            // This approach is used on AppTabView and DaoInfoView
            if activeSheetManager.activeSheet == nil {
                activeSheetManager.activeSheet = .signIn
            }
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
