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
    @State private var isAlertPresented = false

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
            .onTapGesture{} // do not delete, otherwise onLongPressGesture breaks the scrollview
            .onLongPressGesture(minimumDuration: 1) {
                UIPasteboard.general.string = markdownDescription
                isAlertPresented.toggle()
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("Copied"),
                      message: Text("Content has been copied to clipboard"),
                      dismissButton: .default(Text("OK")))
            }
            .overlay(
                Group {
                    if !isExpanded {
                        ShadowOverlay()
                    }
                },
                alignment: .bottom)

            // we will always display Show More button
            Button(isExpanded ? "Show Less" : "Show More") {
                if !isExpanded {
                    Tracker.track(.snpDetailsShowFullDscr)
                }
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
