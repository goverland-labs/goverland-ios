//
//  SignInTwoStepsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SignInTwoStepsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var dataSource = SignInTwoStepsDataSource()
    @State private var showSelectWallet = false
    @Setting(\.authToken) private var authToken

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 24))
                }
            }

            Text("Sign In")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)

            Image("wallet")
                .frame(minWidth: 128, maxWidth: 192)
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
                .foregroundColor(.textWhite)

                Spacer()

                if let sessionMeta = dataSource.wcSessionMeta {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            if let iconStr = sessionMeta.session.peer.icons.first,
                               let iconUrl = URL(string: iconStr) {
                                RoundPictureView(image: iconUrl, imageSize: 24)
                            }
                            Image(systemName: "checkmark.circle.fill")
                                .accentColor(.primaryDim)
                                .font(.system(size: 24))
                        }
                        Button(action: {
                            showSelectWallet = true
                        }) {
                            Text("Change wallet")
                                .foregroundColor(.primaryDim)
                                .font(.footnoteRegular)
                        }
                    }
                } else {
                    Circle()
                        .stroke(Color.textWhite, lineWidth: 2)
                        .frame(width: 24)
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
                .foregroundColor(.textWhite)

                Spacer()

                Circle()
                    .stroke(Color.textWhite, lineWidth: 2)
                    .frame(width: 24)
            }

            Spacer()

            if dataSource.wcSessionMeta == nil {
                PrimaryButton("Connect Wallet") {
                    showSelectWallet = true
                }
            } else {
                PrimaryButton("Sign message to sign in") {
                    dataSource.authenticate()
                }
            }
        }
        .padding(16)
        .sheet(isPresented: $showSelectWallet) {
            NavigationStack {
                ConnectWalletView()
            }
            .accentColor(.textWhite)
            .overlay {
                ToastView()
            }
        }
        .onChange(of: authToken) { _, token in
            if !token.isEmpty {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
