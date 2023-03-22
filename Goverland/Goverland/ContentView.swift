//
//  ContentView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//

import SwiftUI

struct ContentView: View {
    @Setting(\.termsAccepted) var termsAccepted
    @Setting(\.onboardingFinished) var onboardingFinished
    @Setting(\.trackingAccepted) var trackingAccepted

    var body: some View {
        if !termsAccepted {
            IntroView()
        } else if !onboardingFinished {
            SelectDaoView()
        } else {
            AppTabView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
