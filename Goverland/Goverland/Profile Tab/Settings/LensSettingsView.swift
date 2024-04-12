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
            Image("lens")
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
            Text("Follow on Lens...")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
            OrbSettingsView()
            HeySettingsView()
        }
        .padding()
    }
}

fileprivate struct OrbSettingsView: View {
    var body: some View {
        HStack {
            Image("orb")
            Text("Orb App")
                .font(.headlineRegular)
                .foregroundStyle(Color.textWhite)
            Spacer()
            PrimaryButton("Open", maxWidth: 100, height: 45) {
                Tracker.track(.settingsOpenOrb)
                Utils.openOrb()
            }
        }
    }
}

fileprivate struct HeySettingsView: View {
    var body: some View {
        HStack {
            Image("hey")
            Text("Hey")
                .font(.headlineRegular)
                .foregroundStyle(Color.textWhite)
            Spacer()
            PrimaryButton("Open", maxWidth: 100, height: 45) {
                Tracker.track(.settingsOpenHey)
                Utils.openHey()
            }
        }
    }
}
