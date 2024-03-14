//
//  PopoverNavigationViewWithToast2.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

/// Wrapper to present view in a popover with own activeSheetManager and ToasView. It is used inside PopoverNavigationViewWithToast
/// becase it is not possible to use recursive approach there.
struct PopoverNavigationViewWithToast2<Content: View>: View {
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
                // Can't use recursive approache here
                // because of compilation error
                PopoverNavigationViewWithToast {
                    DaoInfoView(dao: dao)
                }

            case .publicProfile(let address):
                PopoverNavigationViewWithToast {
                    PublicUserProfileView(address: address)
                }

            case .followDaos:
                PopoverNavigationViewWithToast {
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
