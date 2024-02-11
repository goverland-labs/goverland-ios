//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftDate

// TODO: add pull-to-refresh logic, add initializer from object and from proposal id
struct SnapshotProposalView: View {
    let proposal: Proposal
    let allowShowingDaoInfo: Bool
    let navigationTitle: String

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var voted: Bool {
        proposal.userVote != nil
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                SnapshotProposalHeaderView(title: proposal.title)

                SnapshotProposalCreatorView(dao: proposal.dao, creator: proposal.author)
                    .gesture(TapGesture().onEnded { _ in
                        if allowShowingDaoInfo {
                            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                            Tracker.track(.snpDetailsShowDao)
                        }
                    })
                    .padding(.bottom, 15)

                SnapshotProposalStatusBarView(state: proposal.state, voted: voted, votingEnd: proposal.votingEnd)
                    .padding(.bottom, 20)

                SnapshotProposalDescriptionView(proposalBody: proposal.body)
                    .padding(.bottom, 35)

                HStack {
                    Text("Off-Chain Vote")
                        .font(.headlineSemibold)
                        .foregroundStyle(Color.textWhite)
                    Spacer()
                }
                .padding(.bottom)

                SnapshotProposalVoteTabView(proposal: proposal)
                    .padding(.bottom, 35)
                
                if let discussionURL = proposal.discussion, !discussionURL.isEmpty {
                    SnapshotProposalDiscussionView(proposal: proposal)
                        .padding(.bottom, 35)
                }

                SnapshotProposalTimelineView(timeline: proposal.timeline)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ProposalSharingMenu(link: proposal.link, isRead: nil, markCompletion: nil)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.textWhite)
                        .fontWeight(.bold)
                        .frame(height: 20)
                }
            }
        }
        .onAppear() {
            Tracker.track(.screenSnpDetails)
        }
    }
}

fileprivate struct SnapshotProposalHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .font(.title3Semibold)
            .foregroundStyle(Color.textWhite)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.7)
    }
}

fileprivate struct SnapshotProposalCreatorView: View {
    let dao: Dao
    let creator: User

    var body: some View {
        HStack(spacing: 5) {
            // DAO identity view
            HStack(spacing: 6) {
                RoundPictureView(image: dao.avatar(size: .xs), imageSize: Avatar.Size.xs.daoImageSize)
                Text(dao.name)
                    .font(.footnoteRegular)
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textWhite)

            }
            Text("by")
                .font(.footnoteSemibold)
                .foregroundStyle(Color.textWhite60)
            IdentityView(user: creator)
                .font(.footnoteSemibold)
                .foregroundStyle(Color.textWhite)
            Spacer()
        }
    }
}

fileprivate struct SnapshotProposalStatusBarView: View {
    let state: Proposal.State
    let voted: Bool
    let votingEnd: Date

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(votingEnd.isInPast ? "Vote finished " : "Vote finishes ")
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite)
                DateView(date: votingEnd,
                         style: .numeric,
                         font: .footnoteRegular,
                         color: .primaryDim)
            }
            Spacer()
            HStack(spacing: 6) {
                if voted {
                    BubbleView(
                        image: Image(systemName: "checkmark"),
                        text: nil,
                        textColor: .onSecondaryContainer,
                        backgroundColor: .secondaryContainer)
                }
                ProposalStatusView(state: state)
            }
        }
        .padding(10)
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

fileprivate struct SnapshotProposalDiscussionView: View {
    let proposal: Proposal
    var body: some View {
        VStack{
            HStack {
                Text("Discussion")
                    .font(.headlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }

            HStack(spacing: 15) {
                RoundPictureView(image: proposal.dao.avatar(size: .s), imageSize: Avatar.Size.s.daoImageSize)

                if let urlString = proposal.discussion, let unwrappedURL = URL(string: urlString) {
                    Link(destination: unwrappedURL) {
                        Group {
                            Text("\(proposal.title) \(Image(systemName: "arrow.up.right"))")
                                .foregroundStyle(Color.textWhite)
                        }
                        .multilineTextAlignment(.leading)

                        Spacer()
                    }
                }
            }
            .padding(15)
            .font(.footnoteRegular)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.container)
            )
        }
    }
}

fileprivate struct SnapshotProposalTimelineView: View {
    let timeline: [TimelineEvent]

    var body: some View {
        VStack {
            HStack {
                Text("Timeline")
                    .font(.headlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }

            ForEach(timeline) { t in
                HStack(spacing: 3) {
                    Text(Utils.mediumDate((t.createdAt)))
                    Text("–")
                    Text("\(t.event.localizedName)")
                    Spacer()
                }
                .font(.footnoteRegular)
                .foregroundStyle(Color.textWhite)
                .padding(.vertical, 2)
            }
        }
    }
}
