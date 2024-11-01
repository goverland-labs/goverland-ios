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
                .foregroundStyle(Color.primaryDim)
                .frame(width: 30)
            Button("Follow on X") {
                Tracker.track(.settingsOpenX)
                Utils.openX()
            }
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundStyle(Color.textWhite40)
        }
        .tint(.textWhite)
    }
}
