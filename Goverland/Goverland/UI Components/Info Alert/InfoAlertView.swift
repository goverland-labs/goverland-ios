//
//  InfoAlertView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import MarkdownUI

struct InfoAlertView: View {
    @StateObject var alertModel = InfoAlertModel.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var longMessage: Bool {
        guard let message = alertModel.alertMarkdownMessage else { return false }
        return message.count > 512
    }

    var body: some View {
        // Assure that there is no other view presented on top, otherwise don't show alert message here
        if let message = alertModel.alertMarkdownMessage, activeSheetManager.activeSheet == nil {
            ZStack {
                Color.black.opacity(0.4) // Dimmed background
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            alertModel.setAllertMarkdownMessage(nil)
                        }
                    }

                VStack(spacing: 12) {
                    if longMessage {
                        ScrollView {
                            Markdown(message)
                                .markdownTheme(.goverland)
                        }
                        .scrollIndicators(.hidden)
                    } else {
                        Markdown(message)
                            .markdownTheme(.goverland)
                    }

                    SecondaryButton("Close", maxWidth: 160, height: 32, font: .footnoteSemibold) {
                        withAnimation {
                            alertModel.setAllertMarkdownMessage(nil)
                        }
                    }
                    .padding(.top, 8)
                }
                .if(longMessage) { view in
                    view.frame(idealWidth: 300, maxHeight: 400)
                }
                .if(!longMessage) { view in
                    view.frame(idealWidth: 300)
                }
                .padding()
                .background(Color.containerBright)
                .cornerRadius(20)
            }
        }
    }
}
