//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

fileprivate enum _DescriptionTab: Int, Identifiable {
    var id: Int { self.rawValue }

    case full = 0
    case ai

    static var allTabs: [_DescriptionTab] {
        [.full, .ai]
    }

    func image(replaceWand: Bool) -> Image {
        switch self {
        case .full:
            return Image(systemName: "scroll")
        case .ai:
            return Image(systemName: replaceWand ? "eyes" : "wand.and.stars")
        }
    }
}

struct SnapshotProposalDescriptionView: View {
    @StateObject private var dataSource: SnapshotProposalDescriptionViewDataSource
    @Query private var profiles: [UserProfile]
    @Setting(\.authToken) private var authToken
    @Setting(\.lastViewed_AI_SummaryTime) private var lastViewed_AI_SummaryTime

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

    let minCharsForShowMore = 300

    @State private var replaceWand = false

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

    var shouldHintWand: Bool {
        let now = Date().timeIntervalSinceReferenceDate
        return now - lastViewed_AI_SummaryTime > ConfigurationManager.hint_AI_summaryRequestInterval
    }

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
                            tab.image(replaceWand: replaceWand)
                                .foregroundStyle(Color.onSecondaryContainer)
                                .if(tab == .ai && shouldHintWand) { view in
                                    view
                                        .contentTransition(.symbolEffect(.replace))
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                replaceWand = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                                replaceWand = false
                                            }
                                        }
                                }
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
                    GMarkdown(markdownDescription)
                case .ai:
                    if userSignedIn {
                        Group {
                            if let aiMarkdownDescription = dataSource.aiDescription {
                                GMarkdown(aiMarkdownDescription)
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
                        .onAppear {
                            lastViewed_AI_SummaryTime = Date().timeIntervalSinceReferenceDate
                        }
                    } else { // user is guest or not signed in
                        VStack(alignment: .leading) {
                            InfoMessageView(message: "Please sign in to access the AI summarization for this proposal")
                                .padding(.vertical, 20)
                            PrimaryButton("Sign in with wallet",
                                          height: 40,
                                          font: .footnoteSemibold) {
                                Haptic.medium()
                                showSignIn = true
                            }
                        }
                        .onAppear {
                            lastViewed_AI_SummaryTime = Date().timeIntervalSinceReferenceDate
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(maxHeight: dataSource.descriptionIsExpanded ? .infinity : heightLimit)
            .onTapGesture {} // do not delete, otherwise onLongPressGesture breaks the scrollview
            .onLongPressGesture(minimumDuration: 1) {
                switch chosenTab {
                case .full:
                    UIPasteboard.general.string = markdownDescription
                case .ai:
                    guard let aiMarkdownDescription = dataSource.aiDescription else { return }
                    UIPasteboard.general.string = aiMarkdownDescription
                }

                showToast("Content copied to clipboard")
            }

            switch chosenTab {
            case .full:
                if markdownDescription.count > minCharsForShowMore {
                    _ShowMoreButton(dataSource: dataSource)
                        .padding(.top, 8)
                }
            case .ai:
                if let aiMarkdownDescription = dataSource.aiDescription, aiMarkdownDescription.count > minCharsForShowMore {
                    _ShowMoreButton(dataSource: dataSource)
                        .padding(.top, 8)
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
