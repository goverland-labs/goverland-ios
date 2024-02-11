//
//  DeleteProfilePopoverView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DeleteProfilePopoverView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Are you sure?")
                .font(.title3Semibold)
                .foregroundStyle(Color.textWhite)
                .padding(.top, 16)                

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("This profile will no longer be available, and all your saved data will be permanently deleted from all connected devices.")

                Text("Deleting your account can’t be undone.")
            }
            .font(.bodyRegular)
            .foregroundStyle(Color.textWhite)

            Spacer()

            HStack(spacing: 16) {
                DangerButton("Delete") {
                    Haptic.heavy()
                    ProfileDataSource.shared.deleteProfile()
                    Tracker.track(.deleteProfile)
                    dismiss()
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
