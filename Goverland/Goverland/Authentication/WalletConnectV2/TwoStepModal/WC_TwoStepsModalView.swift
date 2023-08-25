//
//  WC_TwoStepsModalView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.08.23.
//

import SwiftUI

struct WC_TwoStepsModalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var model = WC_TwoStepsViewModel()
    
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

            Text("You can use any WalletConnect supported wallet.")

            // TODO: add message to outreach support channel if smth doesn't work

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
                            WC_Manager.showModal()
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
                    WC_Manager.showModal()
                }
            } else {
                PrimaryButton("Sign Message to Sign In") {
                    model.authenticate()
                }
            }
        }
        .padding(16)
    }
}

struct WC_TwoStepsView_Previews: PreviewProvider {
    static var previews: some View {
        WC_TwoStepsModalView()
    }
}
