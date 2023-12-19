//
//  XSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct XSettingsView: View {
    var body: some View {
        HStack {
            Image("x")
                .foregroundColor(.primaryDim)
                .frame(width: 30)
            Button("Follow on X", action: openXApp)
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundColor(.textWhite40)
        }
        .accentColor(.textWhite)
    }
    
    private func openXApp() {
        let url = URL(string: "https://x.com/goverland_xyz")!
        openUrl(url)
        Tracker.track(.settingsOpenX)
    }
}
