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

    var body: some View {
        VStack {
            Text("Do you want to sign out?")
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
                .padding(.top, 20)
                .padding(.bottom, 16)

            Spacer()

            HStack(spacing: 16) {
                PrimaryButton("Sign out") {
                    // sign out logic
                }
                SecondaryButton("Cancel") {
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
