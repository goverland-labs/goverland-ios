//
//  SignInView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import SwiftUI


struct SignInView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var presentModal = false

    var body: some View {
        VStack {
            PrimaryButton("Sign In with Wallet") {
                presentModal = true
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
        .sheet(isPresented: $presentModal) {
            WC_ModalView()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
