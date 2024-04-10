//
//  LensSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-04-10.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct LensSettingsView: View {
    var body: some View {
        HStack {
            Image("x") //Image("lens")
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Follow on Lens") {
                Tracker.track(.settingsOpenLens)
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}

struct LensPopoverView: View {
    var body: some View {
        VStack(spacing: 20) {
            OrbSettingsView()
            HeySettingsView()
        }
        .padding()
    }
}

fileprivate struct OrbSettingsView: View {
    var body: some View {
        HStack {
            Image("x") //Image("orb")
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Follow on Orb") {
                Tracker.track(.settingsOpenOrb)
                Utils.openOrb()
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}

fileprivate struct HeySettingsView: View {
    var body: some View {
        HStack {
            Image("x") //Image("hey")
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Follow on Hey") {
                Tracker.track(.settingsOpenHey)
                Utils.openHey()
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}
