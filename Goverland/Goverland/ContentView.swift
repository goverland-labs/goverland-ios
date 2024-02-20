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
    @StateObject var remoteConfig = RemoteConfigManager.shared
    
    var body: some View {
        if remoteConfig.isUpdateNeeded {
            AppUpdateBlockingView()
        } else if !termsAccepted {
            IntroView()
        } else {
            AppTabView()
        }
    }
}
