//
//  DiscordSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-31.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DiscordSettingsView: View {
    var body: some View {
        HStack {
            Image("discord")
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Discord") {
                Tracker.track(.settingsOpenDiscord)
                Utils.openDiscord()
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}
