//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.06.23.
//

import SwiftUI
import MarkdownUI

struct SnapshotProposalDescriptionView: View {
    let proposalBody: [Proposal.ProposalBody]

    // TODO: fix when backend is ready
    var markdownDescription: String {
        // we always expect to have a markdown text
        let rawStr = proposalBody.first { $0.type == .markdown }!.body
        return rawStr.replacingOccurrences(of: "ipfs://", with: "https://snapshot.mypinata.cloud/ipfs/")
    }

    @State private var isExpanded = false

    var heightLimit: CGFloat {
        // can be calculated based on device
        return 250
    }

    var body: some View {
        VStack {
            ScrollView {
                Markdown(markdownDescription)
                    .markdownTheme(.goverland)
            }
            .scrollDisabled(true)
            .frame(maxHeight: isExpanded ? .infinity : heightLimit)
            .overlay(
                Group {
                    if !isExpanded {
                        ShadowOverlay()
                    }
                },
                alignment: .bottom)

            // we will always display Show More button
            Button(isExpanded ? "Show Less" : "Show More") {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .frame(width: 100, height: 30, alignment: .center)
            .background(Capsule(style: .circular)
                .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 2)))
            .tint(.onSecondaryContainer)
            .font(.footnoteSemibold)
        }
    }
}

fileprivate struct ShadowOverlay: View {
    var body: some View {
        Rectangle().fill(
            LinearGradient(colors: [.clear, .surface.opacity(0.8)],
                           startPoint: .top,
                           endPoint: .bottom))
        .frame(height: 50)
    }
}

extension Theme {
    static let goverland = Theme()
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
        }
        .link {
            ForegroundColor(.primary)
        }
        .text {
            ForegroundColor(.textWhite)
            FontFamilyVariant(.normal)
            FontStyle(.normal)
            FontSize(.em(1))
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
}
