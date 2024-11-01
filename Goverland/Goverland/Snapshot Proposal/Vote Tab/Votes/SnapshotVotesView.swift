//
//  SnapshotVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotVotesView<ChoiceType: Decodable>: View {
    private let proposal: Proposal
    @StateObject private var dataSource: SnapshotVotesDataSource<ChoiceType>
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(proposal: Proposal) {
        self.proposal = proposal
        _dataSource = StateObject(wrappedValue: SnapshotVotesDataSource<ChoiceType>(proposal: proposal))
    }

    var body: some View {
        VStack {
            HStack {
                Text("Votes \(dataSource.totalVotes)")
                    .font(.footnoteRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }

            if dataSource.isLoading {
                ShimmerVoteListItemView()
                    .padding(6)
            } else {
                let count = dataSource.votes.count
                ForEach(0..<min(5, count), id: \.self) { index in
                    let vote = dataSource.votes[index]
                    Divider()
                    VoteListItemView(proposal: proposal, vote: vote)
                }

                if dataSource.totalVotes >= 5 {
                    VStack {
                        Spacer()
                            .padding(.bottom, 8)
                        Text("See all")
                            .frame(width: 124, height: 32, alignment: .center)
                            .background(Capsule(style: .circular)
                                .stroke(Color.secondaryContainer,style: StrokeStyle(lineWidth: 1)))
                            .tint(.onSecondaryContainer)
                            .font(.footnoteSemibold)
                            .onTapGesture {
                                activeSheetManager.activeSheet = .proposalVoters(proposal)
                            }
                    }
                }
            }
        }
        .listRowSeparator(.hidden)
        .onAppear() {
            dataSource.refresh()
        }
    }
}

struct VoteListItemView<ChoiceType: Decodable>: View {
    let proposal: Proposal
    let vote: Vote<ChoiceType>
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var byUser: Bool {
        guard let user = ProfileDataSource.shared.profile?.account else { return false }
        return vote.voter == user
    }

    var body: some View {
        HStack {
            IdentityView(user: vote.voter, font: byUser ? .footnoteSemibold : nil) {
                activeSheetManager.activeSheet = .publicProfileById(vote.voter.address.value)
                Tracker.track(.snpDetailsVotesShowUserProfile)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if proposal.privacy == .shutter && proposal.state == .active {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.textWhite)
            } else {
                Text(vote.choiceStr(for: proposal) ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.footnoteRegular)
                    .foregroundStyle(byUser ? Color.textWhite : .textWhite40)
            }

            HStack {
                Text("\(String(Utils.formattedNumber(vote.votingPower))) Votes")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(byUser ? .footnoteSemibold : .footnoteRegular)
                    .foregroundStyle(Color.textWhite)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                if let reason = vote.message, !reason.isEmpty {
                    Image(systemName: "text.bubble.fill")
                        .foregroundStyle(Color.secondaryContainer)
                }
            }
        }
        .padding(6)
        .font(.footnoteRegular)
        .contentShape(Rectangle())
        .onTapGesture {
            if let reason = vote.message, !reason.isEmpty {
                let formattedReason = Utils.textWithLinkToMarkdownText(reason)
                let message = """
## Reason

\(formattedReason)
"""
                showInfoAlert(message)
            }
        }
    }
}

struct ShimmerVoteListItemView: View {
    var body: some View {
        HStack {
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(10)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
            Spacer()
            ShimmerView()
                .frame(width: 60, height: 20)
                .cornerRadius(8)
        }
    }
}
