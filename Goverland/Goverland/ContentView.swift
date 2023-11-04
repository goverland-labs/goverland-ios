//
//  ContentView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Setting(\.termsAccepted) var termsAccepted
    @Setting(\.onboardingFinished) var onboardingFinished

    var body: some View {
        if !termsAccepted {
            IntroView()
        } else if !onboardingFinished {
            EnablePushNotificationsView()
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
