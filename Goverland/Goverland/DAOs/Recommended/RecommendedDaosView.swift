//
//  RecommendedDaosView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct RecommendedDaosView: View {
    let daos: [Dao]
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textWhite40)
                        .font(.system(size: 26))
                }
            }

            Text("Daos count: \(daos.count)")

            Spacer()
        }
    }
}
