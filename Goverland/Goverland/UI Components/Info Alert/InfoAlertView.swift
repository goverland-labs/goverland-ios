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

    var body: some View {
        if let message = alertModel.alertMarkdownMessage {
            ZStack {
                Color.black.opacity(0.4) // Dimmed background
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            alertModel.setAllertMarkdownMessage(nil)
                        }
                    }

                VStack(spacing: 12) {
                    ScrollView {
                        Markdown(message)
                            .markdownTheme(.goverland)
                    }
                    .scrollIndicators(.hidden)

                    SecondaryButton("Close", height: 32, font: .footnoteSemibold) {
                        withAnimation {
                            alertModel.setAllertMarkdownMessage(nil)
                        }
                    }
                    .padding(.vertical, 8) 
                }
                .frame(width: 300)
                .padding()
                .background(Color.containerBright)
                .cornerRadius(20)
            }
        }
    }
}
