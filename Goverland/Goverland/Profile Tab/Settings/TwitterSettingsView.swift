//
//  TwitterSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct TwitterSettingsView: View {
    var body: some View {
        HStack {
            Image("twitter")
                .foregroundColor(.primaryDim)
                .frame(width: 30)
            Button("Twitter", action: openTwitterApp)
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundColor(.textWhite40)
        }
        .accentColor(.textWhite)
    }
    
    private func openTwitterApp() {
        let url = URL(string: "https://twitter.com/goverland_xyz")!
        openUrl(url)
        Tracker.track(.settingsOpenTwitter)
    }
}
