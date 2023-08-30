//
//  TwoStepsModalView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
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
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
            }

            Text("Sign In")
                .fontWeight(.bold)
                .font(.title3)

            Text("Connect your wallet and sign a message to sign in.")            

            HStack(alignment: .top) {
                Text("1")
                Text("Connect wallet")
                Spacer()
                if let session = model.wcSession {
                    VStack(alignment: .trailing) {
                        HStack {
                            if let iconStr = session.peer.icons.first,
                               let iconUrl = URL(string: iconStr) {
                                RoundPictureView(image: iconUrl, imageSize: 24)
                            }
                            Image(systemName: "checkmark.circle.fill")
                                .accentColor(.primary)
                        }
                        Button("Change Wallet") {
                            WC_Manager.shared.session = nil
                            showSelectWallet = true
                        }
                        .accentColor(.primary)
                    }
                }
            }

            HStack {
                Text("2")
                Text("Sign message")
                Spacer()
            }

            Spacer()

            if model.wcSession == nil {
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
            .accentColor(.primary)
            .overlay {
                ErrorView()
            }
        }
    }
}

struct WC_TwoStepsView_Previews: PreviewProvider {
    static var previews: some View {
        TwoStepsModalView()
    }
}
