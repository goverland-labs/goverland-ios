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
        VStack(alignment: .center, spacing: 24) {
            Spacer()
            VStack(spacing: 20) {
                HStack {
                    Text("Your inbox is empty")
                    Image(systemName: "envelope.open.fill")
                }
                .font(.titleSemibold)
                .foregroundColor(.textWhite)

                Text("Follow new DAOs to receive updates!")
                    .font(.body)
                    .foregroundColor(.textWhite)

            }
            Spacer()
            PrimaryButton("My followed DAOs") {
                TabManager.shared.selectedTab = .profile
                TabManager.shared.profilePath = [.subscriptions]
            }
            Spacer()
        }
        .padding([.horizontal, .bottom], 16)
        .onAppear {
            Tracker.track(.screenInboxEmpty)
        }
    }
}
