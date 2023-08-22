//
//  SignInView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import SwiftUI
import WalletConnectModal


struct SignInView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var model = SignInViewModel()

    var body: some View {
        VStack {
            PrimaryButton("Sign In with Wallet") {
                WalletConnectModal.present()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Sign In")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
