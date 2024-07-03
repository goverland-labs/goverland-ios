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
    case delegates
    case about

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .insights:
            return "Insights"
        case .delegates:
            return "Delegates"
        case .about:
            return "About"
        }
    }
}

struct DaoInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataSource: DaoInfoDataSource
    @State private var filter: DaoInfoFilter = .activity
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

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
                    case .insights: DaoInsightsView(dao: dao)
                    case .delegates: DaoDelegatesView(dao: dao)
                    case .about: DaoInfoAboutDaoView(dao: dao)
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
        .onReceive(NotificationCenter.default.publisher(for: .unauthorizedActionAttempt)) { notification in
            // This approach is used on AppTabView and DaoInfoView
            if activeSheetManager.activeSheet == nil {
                activeSheetManager.activeSheet = .signIn
            }
        }
        .onChange(of: lastAttemptToPromotedPushNotifications) { _, _ in
            showEnablePushNotificationsIfNeeded(activeSheetManager: activeSheetManager)
        }
        .onAppear {
            if dataSource.dao == nil {
                dataSource.refresh()
            }
        }
    }
}
