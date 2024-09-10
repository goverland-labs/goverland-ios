//
//  MarkdownTheme.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import MarkdownUI
import SwiftUI

struct GMarkdown: View {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Markdown(message)
            .markdownTheme(.goverland)
            .environment(\.openURL, OpenURLAction { url in
                logInfo("[Markdown] Intercepted URL in Alert View: \(url.absoluteString)")

                if url.absoluteString.contains("https://support.ens.domains/en/articles/7883271") {
                    Tracker.track(.openEnsHelpArticle)
                }

                // Return .handled if you handled the URL, or .systemAction to let the system handle it
                return .systemAction
            })
    }
}

extension Theme {
    // .gitHub theme as a guidance
    static let goverland = Theme()
        .text {
            ForegroundColor(.textWhite)
            BackgroundColor(.clear)
            FontSize(.em(0.85))
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
            BackgroundColor(.secondaryContainer)
        }
        .strong {
            FontWeight(.semibold)
        }
        .link {
            ForegroundColor(.primaryDim)
        }
        .heading1 { configuration in
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .relativePadding(.bottom, length: .em(0.3))
                    .relativeLineSpacing(.em(0.125))
                    .markdownMargin(top: 24, bottom: 16)
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(.em(1.3))
                    }
                Divider()//.overlay(Color.textWhite20)
            }
        }
        .heading2 { configuration in
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .relativePadding(.bottom, length: .em(0.3))
                    .relativeLineSpacing(.em(0.125))
                    .markdownMargin(top: 24, bottom: 16)
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(.em(1.1))
                    }
                Divider()//.overlay(Color.textWhite20)
            }
        }
        .heading3 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(1.0))
                }
        }
        .heading4 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(0.9))
                }
        }
        .heading5 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(0.85))
                }
        }
        .heading6 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(0.8))
                    //              ForegroundColor(.tertiaryText)
                }
        }
        .paragraph { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                Rectangle() // left quote line
                    .fill(Color.containerDim)
                    .relativeFrame(width: .em(0.2))
                configuration.label
                    .markdownTextStyle {
                        FontStyle(.italic)
                    }
                    .relativePadding(.horizontal, length: .em(1))
                    .relativePadding(.vertical, length: .em(0.5))
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(Color.containerBright)
        }
        .codeBlock { configuration in
            ScrollView(.horizontal) {
                configuration.label
                    .fixedSize(horizontal: false, vertical: true)
                    .relativeLineSpacing(.em(0.225))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                        ForegroundColor(.onSecondaryContainer)
                    }
                    .padding(16)
            }
            .background(Color.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .markdownMargin(top: 0, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
        .taskListMarker { configuration in
            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.textWhite, Color.clear)
                .imageScale(.medium)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
        .table { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTableBorderStyle(.init(color: .textWhite40))
                .markdownTableBackgroundStyle(
                    .alternatingRows(Color.clear, Color.clear)
                )
                .markdownMargin(top: 0, bottom: 16)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    if configuration.row == 0 {
                        FontWeight(.semibold)
                    }
                    BackgroundColor(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .relativeLineSpacing(.em(0.25))
        }
        .thematicBreak {
            Divider()
                .relativeFrame(height: .em(0.25))
                .markdownMargin(top: 24, bottom: 24)
        }
}
