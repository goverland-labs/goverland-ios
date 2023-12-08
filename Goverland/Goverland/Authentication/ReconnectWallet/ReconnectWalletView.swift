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
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 24))
                }
            }
            .padding(16)

            Text("Your WalletConnect session expired. Please reconnect your wallet.")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
                .multilineTextAlignment(.center)
                .padding(16)

            IdentityView(user: user, size: .medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Capsule(style: .circular)
                    .stroke(Color.textWhite40, style: StrokeStyle(lineWidth: 1)))

            if wrongWalletConnected {
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.textWhite)
                        Text("Please connect your profile wallet with the address displayed above. If you want to vote with another wallet, please log in with another profile.")
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                }
                .background {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.containerBright)
                }

                Spacer()
            }

            Spacer()

            ZStack {
                Image("reconnect-wallet")
                    .scaledToFit()

                VStack {
                    Spacer()
                    PrimaryButton("Reconnect your wallet") {
                        showSelectWallet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showSelectWallet) {
            NavigationStack {
                ConnectWalletView()
            }
            .accentColor(.textWhite)
            .overlay {
                ToastView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            guard let sessionMeta = WC_Manager.shared.sessionMeta, !sessionMeta.isExpired else { return }

            if sessionMeta.session.accounts.first?.address.lowercased() != user.address.value.lowercased() {
                wrongWalletConnected = true
                return
            }

            dismiss()
        }
    }
}
