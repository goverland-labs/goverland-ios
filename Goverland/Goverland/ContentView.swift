//
//  ContentView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var appSettings: [AppSettings]

    var termsAccepted: Bool {
        appSettings.first?.termsAccepted ?? false
    }

    var body: some View {
        if !termsAccepted {
            IntroView()
        } else {
            AppTabView()
        }
    }
}
