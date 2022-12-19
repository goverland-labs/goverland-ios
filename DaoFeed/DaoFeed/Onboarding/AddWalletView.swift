//
//  AddWalletView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct AddWalletView: View {
    @Setting(\.onboardingFinished) var onboardingFinished

    var body: some View {
        Text("Add Wallet View")
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
