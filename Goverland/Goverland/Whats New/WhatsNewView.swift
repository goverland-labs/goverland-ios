//
//  WhatsNewView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct WhatsNewView: View {
    let displayCloseButton: Bool

    @Environment(\.dismiss) private var dismiss

    private var markdown: String {
        WhatsNewDataSource.shared.markdown
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                GMarkdown(markdown)
            }
            .scrollIndicators(.hidden)

            if displayCloseButton {
                SecondaryButton("Close") {
                    dismiss()
                }
                .padding(.vertical, 8)                
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, 20)
        .navigationTitle("What's new")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Tracker.track(.screenWhatsNew)
        }
    }
}
