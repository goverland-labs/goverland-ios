//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftDate

struct SnapshotProposalView: View {
    let allowShowingDaoInfo: Bool

    /// 16.02.2024
    /// On iPad on the latest version (17.3.1) if we use here StateObject instead of ObservedObject, the redraw cycle is broken.
    /// iPad takes some old cached value of dataSource, because the view that we try to redraw is still on the screen.
    @ObservedObject private var dataSource: SnapshotProposalDataSource

    init(proposal: Proposal, allowShowingDaoInfo: Bool) {
        self.allowShowingDaoInfo = allowShowingDaoInfo
        _dataSource = ObservedObject(wrappedValue: SnapshotProposalDataSource(proposal: proposal))
    }

    var proposal: Proposal? {
        dataSource.proposal
    }

    var body: some View {
        Group {
            if dataSource.isLoading {
                VStack {
                    ProgressView()
                        .foregroundStyle(Color.textWhite20)
                        .controlSize(.regular)
                    Spacer()
                }
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the proposal information")
            } else if let proposal {
                _ProposalView(proposal: proposal, allowShowingDaoInfo: allowShowingDaoInfo)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let proposal {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ProposalSharingMenu(link: proposal.link)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }
        .refreshable {
            dataSource.refresh()
        }
        .onAppear() {
            Tracker.track(.screenSnpDetails)
        }
    }
}

fileprivate struct _ProposalView: View {
    let proposal: Proposal
    let allowShowingDaoInfo: Bool
    @StateObject private var dataSource: SnapshotProposalTopVotersDataSource

    init(proposal: Proposal, allowShowingDaoInfo: Bool) {
        self.proposal = proposal
        self.allowShowingDaoInfo = allowShowingDaoInfo
        let dataSource = SnapshotProposalTopVotersDataSource(proposal: proposal)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var voted: Bool {
        proposal.userVote != nil
    }

    var shouldShowTopVoters: Bool {
        guard let topVoters = dataSource.topVoters else { return true } // show when data is loading
        return !topVoters.isEmpty // don't show the loading state or when no voters yet
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                _SnapshotProposalCreatorView(dao: proposal.dao,
                                             creator: proposal.author,
                                             allowShowingDaoInfo: allowShowingDaoInfo,
                                             proposal: proposal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                _SnapshotProposalHeaderView(title: proposal.title)
                    .padding(.bottom, 16)

                _SnapshotProposalStatusBarView(state: proposal.state, voted: voted, votingEnd: proposal.votingEnd)
                    .padding(.bottom, 16)

                SnapshotProposalDescriptionView(proposalBody: proposal.body)
                    .padding(.bottom, 32)

                HStack {
                    Text("Off-Chain Vote")
                        .font(.headlineSemibold)
                        .foregroundStyle(Color.textWhite)
                    Spacer()
                }
                .padding(.bottom)

                SnapshotProposalVoteTabView(proposal: proposal)
                    .padding(.bottom, 32)

                if shouldShowTopVoters {
                    SnapshotProposalTopVotersView(dataSource: dataSource)
                        .padding(.bottom, 32)
                }

                if let discussionURL = proposal.discussion, !discussionURL.isEmpty {
                    _SnapshotProposalDiscussionView(proposal: proposal)
                        .padding(.bottom, 32)
                }

                SnapshotProposalTimelineView(timeline: proposal.timeline)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct _SnapshotProposalHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3Semibold)
            .foregroundStyle(Color.textWhite)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.7)
    }
}

fileprivate struct _SnapshotProposalCreatorView: View {
    let dao: Dao
    let creator: User
    let allowShowingDaoInfo: Bool
    let proposal: Proposal
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        HStack(spacing: 6) {
            // DAO identity view
            HStack(spacing: 6) {
                RoundPictureView(image: dao.avatar(size: .xs), imageSize: Avatar.Size.xs.daoImageSize)

                HStack(spacing: 4) {
                    Text(dao.name)
                        .font(.footnoteRegular)
                        .lineLimit(1)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textWhite)

                    if dao.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.textWhite)
                            .font(.system(size: 14))
                    }
                }
            }
            .gesture(TapGesture().onEnded { _ in
                if allowShowingDaoInfo {
                    activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    Tracker.track(.snpDetailsShowDao)
                }
            })
            Text("by")
                .font(.footnoteSemibold)
                .foregroundStyle(Color.textWhite60)
            
            IdentityView(user: creator) {
                activeSheetManager.activeSheet = .publicProfile(creator.address)
                Tracker.track(.snpDetailsShowUserProfile)
            }

            Spacer()
        }
    }
}

fileprivate struct _SnapshotProposalStatusBarView: View {
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

fileprivate struct _SnapshotProposalDiscussionView: View {
    let proposal: Proposal
    @Environment(\.isPresented) private var isPresented

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
                    .foregroundStyle(isPresented ? Color.containerBright : Color.container)
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
