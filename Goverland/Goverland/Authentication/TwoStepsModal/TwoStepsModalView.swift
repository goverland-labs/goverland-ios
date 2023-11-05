//
//  TwoStepsModalView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct TwoStepsModalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var model = TwoStepsViewModel()
    @State private var showSelectWallet = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 26))
                }
            }

            Spacer()

            Text("Sign In")
                .fontWeight(.bold)
                .font(.title3)

            Text("Connect your wallet and sign a message to sign in.")            

            HStack(alignment: .top) {
                Text("1")
                Text("Connect wallet")
                Spacer()
                if let sessionMeta = model.wcSessionMeta {
                    VStack(alignment: .trailing) {
                        HStack {
                            if let iconStr = sessionMeta.session.peer.icons.first,
                               let iconUrl = URL(string: iconStr) {
                                RoundPictureView(image: iconUrl, imageSize: 24)
                            }
                            Image(systemName: "checkmark.circle.fill")
                                .accentColor(.primaryDim)
                        }
                        Button("Change Wallet") {
                            showSelectWallet = true
                        }
                        .accentColor(.primaryDim)
                    }
                }
            }

            HStack {
                Text("2")
                Text("Sign message")
                Spacer()
            }

            Spacer()

            if model.wcSessionMeta == nil {
                PrimaryButton("Connect Wallet") {
                    showSelectWallet = true
                }
            } else {
                PrimaryButton("Sign Message to Sign In") {
                    model.authenticate()
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
    }
}
