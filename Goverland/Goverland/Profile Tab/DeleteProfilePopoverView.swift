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
                .foregroundColor(.textWhite)
                .padding([.top, .bottom], 32)

            VStack(alignment: .leading, spacing: 20) {
                Text("This profile will no longer be available, and all your saved data will be permanently deleted from all connected devices.")

                Text("Deleting your account can’t be undone.")
            }
            .font(.bodyRegular)
            .foregroundColor(.textWhite)

            Spacer()

            HStack(spacing: 16) {
                DangerButton("Delete") {
                    ProfileDataSource.shared.deleteProfile()
                    dismiss()
                    // TODO: track
                }

                SecondaryButton("Cancel") {
                    dismiss()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
