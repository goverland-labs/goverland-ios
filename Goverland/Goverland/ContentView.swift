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

    var body: some View {
        ZStack {
            if !termsAccepted {
                IntroView()
            } else if !onboardingFinished {
                FollowGroupDaosView()
            } else {
                AppTabView()
            }

            ErrorView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
