//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData
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
    @Query private var profiles: [UserProfile]
    @Setting(\.authToken) private var authToken

    @State private var chosenTab: _DescriptionTab {
        didSet {
            if chosenTab == .ai {
                Tracker.track(.snpDetailsViewSummary)                
                if userSignedIn && dataSource.aiDescription == nil {
                    dataSource.refresh()
                }
            }
        }
    }
    @State private var showSignIn = false
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

    var heightLimit: CGFloat {
        // can be calculated based on device
        return 250
    }

    var userSignedIn: Bool {
        guard let selected = profiles.first(where: { $0.selected }) else { return false }
        return !selected.isGuest
    }

    let minCharsForShowMore = 300

    var body: some View {
        VStack {
            HStack {
                Spacer()

                HStack {
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
                .background(Capsule(style: .circular)
                    .stroke(Color.secondaryContainer, style: StrokeStyle(lineWidth: 1)))
            }

            ScrollView {
                switch chosenTab {
                case .full:
                    Markdown(markdownDescription)
                        .markdownTheme(.goverland)
                case .ai:
                    if userSignedIn {
                        Group {
                            if let aiMarkdownDescription = dataSource.aiDescription {
                                Markdown(aiMarkdownDescription)
                                    .markdownTheme(.goverland)
                            } else if dataSource.isLoading {
                                ProgressView()
                                    .foregroundStyle(Color.textWhite20)
                                    .controlSize(.regular)
                                    .padding()
                            } else if dataSource.failedToLoadInitialData {
                                RefreshIcon {
                                    dataSource.refresh()
                                }
                            } else if dataSource.limitReachedOnSummary {
                                Text("You've reached your AI summarization limit for this month. Your usage will reset at the beginning of next month. Thank you for your understanding!")
                                    .font(.bodyRegular)
                                    .foregroundStyle(Color.textWhite)
                            }
                        }
                    } else { // user is guest or not signed in
                        VStack(alignment: .leading) {
                            Text("Please sign in to access the AI summarization for this proposal")
                                .font(.bodyRegular)
                                .foregroundStyle(Color.textWhite)
                            PrimaryButton("Sign in with wallet",
                                          height: 40,
                                          font: .footnoteSemibold) {
                                Haptic.medium()
                                showSignIn = true
                            }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(maxHeight: dataSource.descriptionIsExpanded ? .infinity : heightLimit)
            .onTapGesture {} // do not delete, otherwise onLongPressGesture breaks the scrollview
            .onLongPressGesture(minimumDuration: 1) {
                UIPasteboard.general.string = markdownDescription
                showToast("Content copied to clipboard")
            }

            switch chosenTab {
            case .full:
                if markdownDescription.count > minCharsForShowMore {
                    _ShowMoreButton(dataSource: dataSource)
                }
            case .ai:
                if let aiMarkdownDescription = dataSource.aiDescription, aiMarkdownDescription.count > minCharsForShowMore {
                    _ShowMoreButton(dataSource: dataSource)
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView { /* do nothing on sign in */ }
                .presentationDetents([.height(500), .large])
        }
        .onChange(of: authToken) { _, _ in
            chosenTab = .full
        }
    }
}

fileprivate struct _ShowMoreButton: View {
    @ObservedObject var dataSource: SnapshotProposalDescriptionViewDataSource

    var body: some View {
        Button(dataSource.descriptionIsExpanded ? "Show less" : "Show more") {
            if !dataSource.descriptionIsExpanded {
                Haptic.light()
                Tracker.track(.snpDetailsShowFullDscr)
            }
            withAnimation {
                dataSource.descriptionIsExpanded.toggle()
            }
        }
        .frame(width: 100, height: 30, alignment: .center)
        .background(Capsule(style: .circular)
            .stroke(Color.secondaryContainer, style: StrokeStyle(lineWidth: 1)))
        .tint(.onSecondaryContainer)
        .font(.footnoteSemibold)
    }
}
