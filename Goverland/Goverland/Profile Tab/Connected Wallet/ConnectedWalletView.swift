//
//  ConnectedWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 03.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftDate

struct ConnectedWalletView: View {
    let user: User
    @State private var wcViewId = UUID()
    @State private var showReconnectWallet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connected wallet")
                .font(.subheadlineSemibold)
                .foregroundStyle(Color.textWhite)
                .padding(.top, 16)
                .padding(.horizontal, Constants.horizontalPadding * 2)

            Group {
                if let wallet = ConnectedWallet.current() {
                    _SwipeableConnectedWalletView(wallet: wallet)
                } else {
                    Button {
                        Haptic.medium()
                        showReconnectWallet = true
                    } label: {
                        HStack {
                            Text("Reconnect wallet")
                            Spacer()
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.container)
            .cornerRadius(12)
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .id(wcViewId)
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            // update "Connected wallet" view on session updates
            wcViewId = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: .cbWalletAccountUpdated)) { notification in
            // update "Connected wallet" view on session updates
            wcViewId = UUID()
        }
        .sheet(isPresented: $showReconnectWallet) {
            ReconnectWalletView(user: user)
        }
    }
}

/// Simulation of system List swipeActions
fileprivate struct _SwipeableConnectedWalletView: View {
    let wallet: ConnectedWallet
    @State private var offset = CGFloat.zero
    @State private var showSheet = false
    let buttonWidth: CGFloat = 72
    let height: CGFloat = 72

    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack(spacing: 12) {
                    if let image = wallet.image {
                        image
                            .frame(width: 32, height: 32)
                            .scaledToFit()
                            .cornerRadius(4)
                    } else if let imageUrl = wallet.imageURL {
                        RectanglePictureView(image: imageUrl, imageSize: CGSize(width: 32, height: 32))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(wallet.name)
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textWhite)

                        if let date = wallet.sessionExpiryDate?.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full) {
                            Text("Session expires \(date)")
                                .font(.footnoteRegular)
                                .foregroundStyle(Color.textWhite60)
                        }
                    }

                    Spacer()
                }
                .contentShape(Rectangle())
                .padding(16)
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: self.offset, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 { // swipe left
                                offset = min(offset, gesture.translation.width)
                            } else { // swipe right
                                withAnimation {
                                    self.offset = CGFloat.zero
                                }
                            }
                        }
                        .onEnded { _ in
                            if offset < -buttonWidth {
                                withAnimation {
                                    offset = -buttonWidth
                                }
                            } else {
                                withAnimation {
                                    offset = .zero
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            if offset == 0 {
                                showSheet = true
                            }
                        }
                )

                HStack {
                    Spacer()
                    Image(systemName: "network.slash")
                        .foregroundStyle(Color.textWhite)
                        .font(.system(size: 26))
                    Spacer()
                }
                .frame(width: -offset > buttonWidth ? -offset : buttonWidth, height: height)
                .contentShape(Rectangle())
                .background(Color.red)
                .offset(x: offset)
                .onTapGesture {
                    disconnect()
                }
            }
        }
        .frame(height: height)
        .actionSheet(isPresented: $showSheet) {
            var alertButtons = [Alert.Button]()
            if let redirectUrl = wallet.redirectUrl {
                alertButtons.append(
                    .default(Text("Open wallet")) {
                        openUrl(redirectUrl)
                    }
                )
            }
            alertButtons.append(
                .destructive(Text("Disconnect")) {
                    disconnect()
                }
            )
            alertButtons.append(.cancel())
            return ActionSheet(title: Text(wallet.name),
                               message: nil,
                               buttons: alertButtons)
        }
    }

    private func disconnect() {
        Haptic.medium()

        if wallet.name == Wallet.coinbase.name {
            CoinbaseWalletManager.disconnect()
            Tracker.track(.disconnectCoinbaseWallet)
        } else {
            guard let topic = WC_Manager.shared.sessionMeta?.session.topic else { return }
            WC_Manager.disconnect(topic: topic)
            Tracker.track(.disconnect_WC_session)
        }
    }
}
