//
//  ReconnectWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ReconnectWalletView: View {
    let user: User

    @Environment(\.dismiss) private var dismiss
    @State private var showSelectWallet = false
    @State private var wrongWalletConnected = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textWhite40)
                        .font(.system(size: 24))
                }
            }
            .padding(16)

            Text("Your wallet session expired.\n Please reconnect.")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .multilineTextAlignment(.center)
                .padding(16)

            IdentityView(user: user, size: .s)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Capsule(style: .circular)
                    .stroke(Color.textWhite40, style: StrokeStyle(lineWidth: 1)))

            if wrongWalletConnected {
                InfoMessageView(message: "Please connect your profile wallet with the address displayed above. If you want to vote with another wallet, please sign in with another profile.")
                .padding(16)

                Spacer()
            }

            Spacer()

            ZStack {
                Image("reconnect-wallet")
                    .scaledToFit()

                VStack {
                    Spacer()
                    PrimaryButton("Reconnect your wallet") {
                        Haptic.medium()
                        showSelectWallet = true
                    }
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showSelectWallet) {
            PopoverNavigationViewWithToast {
                ConnectWalletView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            guard let sessionMeta = WC_Manager.shared.sessionMeta, !sessionMeta.isExpired else { return }

            if sessionMeta.session.accounts.first?.address.lowercased() != user.address.value.lowercased() {
                wrongWalletConnected = true
                WC_Manager.disconnect(topic: sessionMeta.session.topic)
                Tracker.track(.reconnectWalletWrongWallet)
                return
            }

            try! UserProfile.update_WC_SessionForSelectedProfile()
            Tracker.track(.reconnectWalletSuccess)

            dismiss()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showToast("Profile wallet successfully reconnected")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .cbWalletAccountUpdated)) { notification in
            guard let account = CoinbaseWalletManager.shared.account else { return }
            
            if account.address.lowercased() != user.address.value.lowercased() {
                wrongWalletConnected = true
                CoinbaseWalletManager.disconnect()
                Tracker.track(.reconnectWalletWrongWallet)
                return
            }

            try! UserProfile.updateCoinbaseWalletAccountForSelectedProfile()
            Tracker.track(.reconnectWalletSuccess)

            dismiss()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showToast("Profile wallet successfully reconnected")
            }
        }
        .onAppear {
            Tracker.track(.screenReconnectWallet)
        }
    }
}
