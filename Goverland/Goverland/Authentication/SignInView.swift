//
//  SignInView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.08.23.
//

import SwiftUI

// TODO: Will be used once we have Sign in with Apple
struct SignInView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var showTwoStepsModal = false

    var body: some View {
        VStack {
            Spacer()
            
            PrimaryButton("Sign In with Wallet") {
                showTwoStepsModal = true
            }
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
                    Text("Sign In")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        .sheet(isPresented: $showTwoStepsModal) {
            TwoStepsModalView()
                .presentationDetents([.medium, .large])
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
