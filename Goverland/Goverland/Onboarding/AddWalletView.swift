//
//  AddWalletView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct AddWalletView: View {
    @Setting(\.onboardingFinished) var onboardingFinished

    var body: some View {
        Spacer()
        Text("Add Wallet View")
        Spacer()
        Button("Finish onboarding") {
            onboardingFinished = true
        }
    }
}

struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletView()
    }
}
