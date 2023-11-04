//
//  EmptyInboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct EmptyInboxView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                Image("looped-line")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width / 2)
                Text("There are no new notifications from the DAOs you follow.\nYou can follow more DAOs or check specific DAO events.")
                    .font(.callout)
                    .foregroundColor(.textWhite)
                Spacer()
                PrimaryButton("My followed DAOs") {
                    TabManager.shared.selectedTab = .settings
                    TabManager.shared.settingsPath = [.subscriptions]
                }
            }
            // this is needed as on iPad GeometryReader breaks VStack layout
            .frame(width: geometry.size.width - 32)
            .padding([.horizontal, .bottom], 16)
            .onAppear {
                Tracker.track(.screenInboxEmpty)
            }
        }
    }
}
