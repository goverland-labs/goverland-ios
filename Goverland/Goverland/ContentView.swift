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
    @StateObject var updateManager = AppUpdateManager.shared
    
    var body: some View {
        if updateManager.isUpdateNeeded {
            AppUpdateBlockingView()
        } else if !termsAccepted {
            IntroView()
        } else {
            AppTabView()
        }
    }
}
