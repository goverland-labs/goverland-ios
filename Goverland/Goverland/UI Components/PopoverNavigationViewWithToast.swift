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
    @StateObject private var activeSheetManager: ActiveSheetManager
    let content: Content

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
                SignInView(source: .popover)

            case .daoInfo(let dao):
                // Can't use recursive approache with PopoverNavigationViewWithToast here
                // because of compilation error
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
                // If ArchiveView is places in NavigationStack, it brakes SwiftUI on iPhone
                ArchiveView()

            case .subscribeToNotifications:
                EnablePushNotificationsView()
            }
        }
        .tint(.textWhite)
        .overlay {
            ToastView()
                .environmentObject(activeSheetManager)
        }
    }
}
