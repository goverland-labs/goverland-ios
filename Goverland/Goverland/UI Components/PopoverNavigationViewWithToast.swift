//
//  PopoverNavigationViewWithToast.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

/// Wrapper to present view in a popover with own activeSheetManager and ToasView.
struct PopoverNavigationViewWithToast<Content: View>: View {
    let content: Content

    @StateObject private var activeSheetManager: ActiveSheetManager
    @StateObject private var recommendedDaosDataSource = RecommendedDaosDataSource.shared
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications

    init(@ViewBuilder content: () -> Content) {
        _activeSheetManager = StateObject(wrappedValue: ActiveSheetManager())
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            content
                .environmentObject(activeSheetManager)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .signIn:
                SignInView(source: .popover) { /* do nothing on sign in */ }

            case .daoInfo(let dao):
                // Can't use recursive approache with PopoverNavigationViewWithToast here
                // because of compilation error
                // TODO: submit issue to Apple
                PopoverNavigationViewWithToast2 {
                    DaoInfoView(dao: dao)
                }

            case .publicProfile(let address):
                PopoverNavigationViewWithToast2 {
                    PublicUserProfileView(address: address)
                }

            case .allDaoVoters(let dao):
                PopoverNavigationViewWithToast2 {
                    AllVotersListView(dao: dao)
                }

            case .followDaos:
                PopoverNavigationViewWithToast2 {
                    AddSubscriptionView()
                }

            case .archive:
                // ArchiveView has path in NavigationStack
                ArchiveView()

            case .subscribeToNotifications:
                EnablePushNotificationsView()

            case .recommendedDaos(let daos):
                RecommendedDaosView(daos: daos) {
                    lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
                }
                .presentationDetents([.height(500), .large])
            }
        }
        .tint(.textWhite)
        .onChange(of: recommendedDaosDataSource.recommendedDaos) { _, daos in
            guard let daos else { return }
            if !daos.isEmpty {
                if activeSheetManager.activeSheet == nil {
                    activeSheetManager.activeSheet = .recommendedDaos(daos)
                }
            } else {
                lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
            }
        }
        .overlay {
            ToastView()
                .environmentObject(activeSheetManager)
        }
    }
}
