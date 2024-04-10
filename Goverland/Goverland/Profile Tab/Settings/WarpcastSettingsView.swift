//
//  WarpcastSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-04-10.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct WarpcastSettingsView: View {
    var body: some View {
        HStack {
            Image("x") //Image("warpcast")
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Follow on Warpcast") {
                Tracker.track(.settingsOpenWarpcast)
                Utils.openWarpcast()
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}
