//
//  SignOutPopoverView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SignOutPopoverView: View {
    @Environment(\.dismiss) private var dismiss
    @Setting(\.authToken) private var authToken

    var body: some View {
        VStack {
            Text("Do you want to sign out?")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .padding(.top, 8)
                .padding(.bottom, 16)

            Spacer()

            HStack(spacing: 16) {
                PrimaryButton("Sign out") {
                    Haptic.medium()
                    ProfileDataSource.shared.signOut(sessionId: authToken)
                    dismiss()
                    Tracker.track(.signOut)
                }
                SecondaryButton("Cancel") {
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}
