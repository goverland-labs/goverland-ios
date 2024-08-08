//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import MarkdownUI

fileprivate enum _DescriptionTab: Int, Identifiable {
    var id: Int { self.rawValue }

    case full = 0
    case ai

    static var allTabs: [_DescriptionTab] {
        [.full, .ai]
    }

    func image() -> Image {
        switch self {
        case .full:
            return Image(systemName: "scroll")
        case .ai:
            return Image(systemName: "wand.and.stars")
        }
    }
}

struct SnapshotProposalDescriptionView: View {
    @StateObject private var dataSource: SnapshotProposalDescriptionViewDataSource
    @State private var chosenTab: _DescriptionTab
    @Namespace var namespace

    init(proposal: Proposal) {
        let dataSource = SnapshotProposalDescriptionViewDataSource(proposal: proposal)
        _dataSource = StateObject(wrappedValue: dataSource)
        _chosenTab = State(wrappedValue: .full)
    }

    var markdownDescription: String {
        // we always expect to have a markdown text
        return dataSource.proposal.body.first { $0.type == .markdown }?.body ?? ""
    }

    @State private var isExpanded = false

    var heightLimit: CGFloat {
        // can be calculated based on device
        return 250
    }

    let minCharsForShowMore = 300

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Spacer()

                ForEach(_DescriptionTab.allTabs) { tab in
                    ZStack {
                        if chosenTab == tab {
                            Circle()
                                .fill(Color.secondaryContainer)
                                .matchedGeometryEffect(id: "tab-background", in: namespace)
                        }
                        tab.image()
                            .foregroundStyle(Color.onSecondaryContainer)
                    }
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            chosenTab = tab
                        }
                    }
                }
            }

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
