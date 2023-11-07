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
    @Setting(\.authToken) private var authToken

    var body: some View {
        if !termsAccepted {
            IntroView()
        } else if authToken.isEmpty {
            SignInView()
        } else {
            AppTabView()
        }
    }
}
