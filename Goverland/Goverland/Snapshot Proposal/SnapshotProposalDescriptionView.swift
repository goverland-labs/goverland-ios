//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import MarkdownUI

struct SnapshotProposalDescriptionView: View {
    let proposalBody: [Proposal.ProposalBody]

    var markdownDescription: String {
        // we always expect to have a markdown text
        return proposalBody.first { $0.type == .markdown }?.body ?? ""
    }

    @State private var isExpanded = false

    var heightLimit: CGFloat {
        // can be calculated based on device
        return 250
    }

    let minCharsForShowMore = 300

    var body: some View {
        VStack {
            ScrollView {
                Markdown(markdownDescription)
                    .markdownTheme(.goverland)
            }
            .scrollDisabled(true)
            .frame(maxHeight: isExpanded ? .infinity : heightLimit)
            .onTapGesture {} // do not delete, otherwise onLongPressGesture breaks the scrollview
            .onLongPressGesture(minimumDuration: 1) {
                UIPasteboard.general.string = markdownDescription
                showToast("Content copied to clipboard")
            }
            .overlay(
                Group {
                    if !isExpanded && markdownDescription.count > minCharsForShowMore {
                        ShadowOverlay()
                    }
                },
                alignment: .bottom)

            // we will always display Show More button
            if markdownDescription.count > minCharsForShowMore {
                Button(isExpanded ? "Show less" : "Show more") {
                    if !isExpanded {
                        Haptic.medium()
                        Tracker.track(.snpDetailsShowFullDscr)
                    }
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .frame(width: 100, height: 30, alignment: .center)
                .background(Capsule(style: .circular)
                    .stroke(Color.secondaryContainer, style: StrokeStyle(lineWidth: 2)))
                .tint(.onSecondaryContainer)
                .font(.footnoteSemibold)
            }
        }
    }
}

fileprivate struct ShadowOverlay: View {
    @Environment(\.isPresented) private var isPresented
    
    private var gradientColors: [Color] {
        return [.clear, .surface.opacity(isPresented ? 0.2 : 0.4)]
    }

    var body: some View {
        Rectangle().fill(
            LinearGradient(colors: gradientColors,
                           startPoint: .top,
                           endPoint: .bottom))
        .frame(height: 50)
    }
}
