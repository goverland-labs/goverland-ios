//
//  ConnectWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI


struct ConnectWalletView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = ConnectWalletModel()

    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("If connecting from other device")) {
                        QRRowView {
                            model.showQR()
                            Tracker.track(.connectWalletShowQR)
                        }
                    }

                    Section {
                        if !Wallet.recommended.isEmpty {
                            ForEach(Wallet.recommended) { wallet in
                                WalletRowView(wallet: wallet, model: model)
                            }
                        } else {
                            ForEach(Wallet.featured) { wallet in
                                DownloadWalletRowView(wallet: wallet)                                
                            }

                            Text("To use the app, you must have a Web3 wallet installed on your mobile device, such as Zerion Wallet.")
                                .foregroundStyle(Color.textWhite60)
                                .font(.footnoteRegular)
                        }
                    }

                    Section {
                        OtherWalletView()
                    }
                }
            }
            .padding(16)

            if model.qrDisplayed {
                WC_QRView(connectWalletModel: model)
                    .ignoresSafeArea(.all)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.textWhite)
                }
            }
            ToolbarTitle("Connect Wallet")            
        }
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            guard notification.object != nil else { return }
            // session settled
            dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: .cbWalletAccountUpdated)) { notification in
            guard notification.object != nil else { return }
            // account received
            dismiss()
        }
        .onAppear {
            Tracker.track(.screencConnectWallet)
        }
    }
}

fileprivate struct QRRowView: View {
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "qrcode")
                .font(.system(size: 32))
            Text("Show QR code")
            Spacer()
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

fileprivate struct OtherWalletView: View {
    var body: some View {
        HStack {
            Image("walletconnect-white")
                .frame(width: 32, height: 32)
                .scaledToFit()
                .cornerRadius(4)
            Text("Other wallet")
            Spacer()
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            Haptic.medium()
            WC_Manager.showModal()
        }
    }
}

fileprivate struct WalletRowView: View {
    let wallet: Wallet
    let model: ConnectWalletModel

    var body: some View {
        HStack {
            Image(wallet.image)
                .frame(width: 32, height: 32)
                .scaledToFit()
                .cornerRadius(4)
            Text(wallet.name)
            Spacer()
            if model.connecting {
                ProgressView()
                    .tint(.textWhite20)
                    .controlSize(.mini)
            }
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            guard !model.connecting else { return }
            Haptic.medium()
            model.connect(wallet: wallet)
        }
    }
}

fileprivate struct DownloadWalletRowView: View {
    let wallet: Wallet

    var body: some View {
        HStack {
            Image(wallet.image)
                .frame(width: 32, height: 32)
                .scaledToFit()
                .cornerRadius(4)
            Text("Download \(wallet.name)")
            Spacer()
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            guard let url = wallet.appStoreUrl else { return }
            Haptic.medium()
            Tracker.track(.downloadWallet, parameters: ["wallet" : wallet.name])
            openUrl(url)
        }
    }
}
