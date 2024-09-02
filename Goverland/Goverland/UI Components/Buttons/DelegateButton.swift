//
//  DelegateButton.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-06.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

/// Delegate button has it's own logic, but will also call a onTap completion if additional logic is needed
struct DelegateButton: View {
    let dao: Dao
    let delegate: Delegate
    let width: CGFloat
    let height: CGFloat
    let onTap: () -> Void

    @Query private var profiles: [UserProfile]
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var showSignIn = false
    @State private var showReconnectWallet = false

    init(dao: Dao,
         delegate: Delegate,
         width: CGFloat = 100,
         height: CGFloat = 32,
         onTap: @escaping () -> Void)
    {
        self.dao = dao
        self.delegate = delegate
        self.width = width
        self.height = height
        self.onTap = onTap
    }

    private var isDelegated: Bool {
        delegate.delegationInfo.percentDelegated != 0
    }

    private var selectedProfile: UserProfile? {
        profiles.first(where: { $0.selected })
    }

    private var selectedProfileIsRegularUser: Bool {
        guard let selectedProfile else { return false }
        return selectedProfile.isRegular
    }

    private var coinbaseWalletConnected: Bool {
        CoinbaseWalletManager.shared.account != nil
    }

    private var wcSessionExistsAndNotExpired: Bool {
        WC_Manager.shared.sessionExistsAndNotExpired
    }

    private var shouldShowReconnectWallet: Bool {
        !(coinbaseWalletConnected || wcSessionExistsAndNotExpired)
    }

    var body: some View {
        Button(action: {
            Haptic.medium()

            if !selectedProfileIsRegularUser {
                showSignIn = true
            } else if shouldShowReconnectWallet {
                showReconnectWallet = true
            } else {
                activeSheetManager.activeSheet = .daoUserDelegate(dao, delegate.user)
            }

            onTap()
        }) {
            HStack {
                Spacer()
                Text(isDelegated ? "Delegated" : "Delegate")
                    .font(.footnoteSemibold)
                    .foregroundColor(Color.textWhite)
                Spacer()
            }
            .frame(width: width, height: height, alignment: .center)
            .background(isDelegated ? Color.tertiaryContainer : Color.clear)
            .background(
                Capsule().stroke(isDelegated ? Color.clear : Color.textWhite, lineWidth: 1)
            )
            .clipShape(Capsule())
            .tint(.onPrimary)
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView { /* do nothing on sign in */ }
                .presentationDetents([.height(500), .large])
        }
        .sheet(isPresented: $showReconnectWallet) {
            ReconnectWalletView(user: selectedProfile!.user)
        }
    }
}
