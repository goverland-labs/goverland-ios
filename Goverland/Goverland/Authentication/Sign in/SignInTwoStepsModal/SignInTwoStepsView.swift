//
//  SignInTwoStepsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SignInTwoStepsView: View {
    let onSignIn: () -> Void

    @StateObject private var dataSource = SignInTwoStepsDataSource()
    @Environment(\.dismiss) private var dismiss
    @Setting(\.authToken) private var authToken

    var body: some View {
        _TwoStepsView(dataSource: dataSource)
            .onChange(of: authToken) { _, token in
                if !token.isEmpty {
                    dismiss()
                    onSignIn()
                }
            }
    }
}

fileprivate struct _TwoStepsView: View {
    @ObservedObject var dataSource: SignInTwoStepsDataSource
    @State private var showSelectWallet = false
    @Environment(\.dismiss) private var dismiss

    var walletConnected: Bool {
        dataSource.wcSessionMeta != nil || dataSource.cbWalletAccount != nil
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textWhite40)
                        .font(.system(size: 26))
                }
            }

            Text("Sign In")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)

            Image("wallet")
                .frame(width: 192)
                .scaledToFit()
                .padding(16)

            HStack(alignment: .top) {
                HStack {
                    Text("1.")
                        .multilineTextAlignment(.trailing)
                        .frame(width: 24)
                    Text("Connect wallet")
                }
                .font(.bodySemibold)
                .foregroundStyle(Color.textWhite)

                Spacer()

                if let sessionMeta = dataSource.wcSessionMeta {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            if let walletImage = sessionMeta.walletImage {
                                walletImage
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            } else if let walletImageUrl = sessionMeta.walletImageUrl {
                                RoundPictureView(image: walletImageUrl, imageSize: 24)
                            }

                            Image(systemName: "checkmark.circle.fill")
                                .tint(.primaryDim)
                                .font(.system(size: 24))
                        }

                        Button(action: {
                            showSelectWallet = true
                        }) {
                            Text("Change wallet")
                                .foregroundStyle(Color.primaryDim)
                                .font(.footnoteRegular)
                        }
                    }
                    .padding(.top, -4)
                } else if dataSource.cbWalletAccount != nil {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            Image(Wallet.coinbase.image)
                                .frame(width: 24, height: 24)
                                .scaledToFit()
                                .clipShape(Circle())

                            Image(systemName: "checkmark.circle.fill")
                                .tint(.primaryDim)
                                .font(.system(size: 24))
                        }

                        Button(action: {
                            showSelectWallet = true
                        }) {
                            Text("Change wallet")
                                .foregroundStyle(Color.primaryDim)
                                .font(.footnoteRegular)
                        }
                    }
                    .padding(.top, -4)
                }
            }

            HStack {
                HStack {
                    Text("2.")
                        .multilineTextAlignment(.trailing)
                        .frame(width: 24)
                    Text("Sign message")
                }
                .font(.bodySemibold)
                .foregroundStyle(Color.textWhite)

                Spacer()
            }
            .padding(.top, walletConnected ? 0 : 16)

            if let message = dataSource.infoMessage {
                InfoMessageView(message: message)
            }

            Spacer()

            if dataSource.wcSessionMeta == nil && dataSource.cbWalletAccount == nil {
                PrimaryButton("Connect wallet") {
                    Haptic.medium()
                    showSelectWallet = true
                }
            } else {
                PrimaryButton("Sign message to sign in") {
                    Haptic.medium()
                    dataSource.authenticate()
                }
            }
        }
        .padding(16)
        .sheet(isPresented: $showSelectWallet) {
            PopoverNavigationViewWithToast {
                ConnectWalletView()
            }
        }
    }
}
