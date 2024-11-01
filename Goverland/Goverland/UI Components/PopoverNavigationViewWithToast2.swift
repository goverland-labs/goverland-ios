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
    let content: Content

    @StateObject private var pathManager: NavigationPathManager
    @StateObject private var activeSheetManager: ActiveSheetManager
    @StateObject private var recommendedDaosDataSource = RecommendedDaosDataSource.shared
    @Setting(\.lastAttemptToPromotedPushNotifications) private var lastAttemptToPromotedPushNotifications

    init(@ViewBuilder content: () -> Content) {
        _pathManager = StateObject(wrappedValue: NavigationPathManager())
        _activeSheetManager = StateObject(wrappedValue: ActiveSheetManager())
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $pathManager.path) {
            content
                .environmentObject(pathManager)
                .environmentObject(activeSheetManager)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .signIn:
                SignInView(source: .popover)

            case .daoInfoById(let daoId):
                // Can't use recursive approache here
                // because of compilation error
                PopoverNavigationViewWithToast {
                    DaoInfoView(daoId: daoId)
                }

            case .publicProfileById(let profileId):
                PopoverNavigationViewWithToast {
                    PublicUserProfileView(profileId: profileId)
                }

            case .daoVoters(let dao, let filteringOption):
                PopoverNavigationViewWithToast {
                    AllDaoVotersListView(dao: dao, filteringOption: filteringOption)
                }

            case .proposalVoters(let proposal):
                PopoverNavigationViewWithToast {
                    SnapshotAllVotesView(proposal: proposal)
                }

            case .followDaos:
                PopoverNavigationViewWithToast {
                    AddSubscriptionView()
                }

            case .notifications:
                PopoverNavigationViewWithToast {
                    InboxView()
                }

            case .archive:
                PopoverNavigationViewWithToast {
                    ArchiveView()
                }

            case .subscribeToNotifications:
                EnablePushNotificationsView()

            case .recommendedDaos(let daos):
                let height = Utils.heightForDaosRecommendation(count: daos.count)
                RecommendedDaosView(daos: daos) {
                    lastAttemptToPromotedPushNotifications = Date().timeIntervalSinceReferenceDate
                }
                .presentationDetents([.height(height), .large])

            case .daoDelegateProfileById(let daoId, let delegateId, let action):
                PopoverNavigationViewWithToast {
                    DaoDelegateProfileView(daoId: daoId, delegateId: delegateId, action: action)
                }

            case .daoUserDelegate(let dao, let user):
                DaoUserDelegationView(dao: dao, delegate: user)
                
            case .proposal(let proposalId):
                PopoverNavigationViewWithToast {
                    SnapshotProposalView(proposalId: proposalId, isRootView: true)
                }
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
            InfoAlertView()
                .environmentObject(activeSheetManager)
        }
        .overlay {
            ToastView()
                .environmentObject(activeSheetManager)
        }
    }
}
