//
//  ContentView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var remoteConfig = RemoteConfigManager.shared
    @Setting(\.termsAccepted) private var termsAccepted

    var body: some View {
        if remoteConfig.isUpdateNeeded {
            AppUpdateBlockingView()
        } else if remoteConfig.isServerMaintenance {
            MaintenanceView()
        } else if !termsAccepted {
            IntroView()
        } else {
            AppTabView()
        }
    }
}
