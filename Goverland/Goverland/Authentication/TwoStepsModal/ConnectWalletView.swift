//
//  ConnectWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 30.08.23.
//

import SwiftUI

struct ConnectWalletView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            Text("Connect Wallet")
        }
        .padding(16)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Connect Wallet")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
    }
}

struct SelectWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectWalletView()
    }
}
