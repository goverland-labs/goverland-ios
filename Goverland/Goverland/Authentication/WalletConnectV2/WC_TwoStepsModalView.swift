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

            Text("Connect to any WalletConnect supported wallet.")

            HStack {
                Text("1")
                Text("Connect wallet")
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .accentColor(.primary)
            }

            HStack {
                Text("2")
                Text("Sign message")
                Spacer()
            }

            Spacer()

            PrimaryButton("Continue") {
                WC_Manager.showModal()
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
