//
//  WhatsNewView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 14.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import MarkdownUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss

    private var markdown: String {
        WhatsNewDataSource.shared.markdown
    }

    var body: some View {
        NavigationView {
            VStack() {
                ScrollView {
                    Markdown(markdown)
                        .markdownTheme(.gitHub)
                }
                .scrollIndicators(.hidden)

                SecondaryButton("Close") {
                    dismiss()
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .navigationTitle("What's new")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
