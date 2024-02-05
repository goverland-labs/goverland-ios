//
//  ConnectedWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 03.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftDate

fileprivate struct ConnectedWallet {
    let image: Image?
    let imageURL: URL?
    let name: String
    let sessionExpiryDate: Date?
    let redirectUrl: URL?
}

struct ConnectedWalletView: View {
    let user: User
    @State private var wcViewId = UUID()
    @State private var showReconnectWallet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connected wallet")
                .font(.subheadlineSemibold)
                .foregroundColor(.textWhite)
                .padding(.top, 16)
                .padding(.horizontal, 16)

            Group {
                if let wallet = connectedWallet() {
                    _SwipeableConnectedWalletView(wallet: wallet)
                } else {
                    Button {
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
            .padding(.horizontal, 8)
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

    private func connectedWallet() -> ConnectedWallet? {
        if CoinbaseWalletManager.shared.account != nil {
            let cbWallet = Wallet.coinbase
            return ConnectedWallet(
                image: Image(cbWallet.image),
                imageURL: nil,
                name: cbWallet.name,
                sessionExpiryDate: nil,
                redirectUrl: cbWallet.link)
        }

        guard let sessionMeta = WC_Manager.shared.sessionMeta, !sessionMeta.isExpired else { return nil }

        let session = sessionMeta.session
        let image: Image?
        let imageUrl: URL?
        let redirectUrl: URL?

        if let imageName = Wallet.by(name: session.peer.name)?.image {
            image = Image(imageName)
        } else {
            image = nil
        }

        if let icon = session.peer.icons.first, let url = URL(string: icon) {
            imageUrl = url
        } else {
            imageUrl = nil
        }

        // custom adjustment for popular wallets
        var name = session.peer.name
        if name == "🌈 Rainbow" {
            name = "Rainbow"
        }

        if let url = session.peer.redirect?.universal {
            redirectUrl = URL(string: url)
        } else {
            redirectUrl = nil
        }

        return ConnectedWallet(image: image,
                               imageURL: imageUrl,
                               name: name,
                               sessionExpiryDate: session.expiryDate,
                               redirectUrl: redirectUrl)
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
                        SquarePictureView(image: imageUrl, imageSize: 32)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(wallet.name)
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)

                        if let date = wallet.sessionExpiryDate?.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full) {
                            Text("Session expires \(date)")
                                .font(.footnoteRegular)
                                .foregroundColor(.textWhite60)
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
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()

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