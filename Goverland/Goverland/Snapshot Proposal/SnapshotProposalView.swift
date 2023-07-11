//
//  SnapshotProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI
import SwiftDate

// TODO: add pull-to-refresh logic, add initializer from object and from proposal id
struct SnapshotProposalView: View {
    let proposal: Proposal
    let allowShowingDaoInfo: Bool
    let navigationTitle: String

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                SnapshotProposalHeaderView(title: proposal.title)

                SnapshotProposalCreatorView(dao: proposal.dao, creator: proposal.author)
                    .gesture(TapGesture().onEnded { _ in
                        if allowShowingDaoInfo {
                            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                        }
                    })
                    .padding(.bottom, 15)

                SnapshotProposalStatusBarView(state: proposal.state, votingEnd: proposal.votingEnd)
                    .padding(.bottom, 20)

                SnapshotProposalDescriptionView(proposalBody: proposal.body)
                    .padding(.bottom, 35)

                HStack {
                    Text("Off-Chain Vote")
                        .font(.headlineSemibold)
                        .foregroundColor(.textWhite)
                    Spacer()
                }
                .padding(.bottom)

                SnapshotProposalVoteTabView(proposal: proposal)
                    .padding(.bottom, 35)

                SnapshotProposalTimelineView()
                    .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ProposalSharingMenu(link: proposal.link)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .frame(height: 20)
                }
            }
        }
        .onAppear() { Tracker.track(.snapshotProposalView) }
    }
}

fileprivate struct SnapshotProposalHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .font(.title3Semibold)
            .foregroundColor(.textWhite)
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
                RoundPictureView(image: dao.avatar, imageSize: 16)
                Text(dao.name)
                    .font(.footnoteRegular)
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .foregroundColor(.textWhite)

            }
            Text("by")
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite60)
            IdentityView(user: creator)
                .font(.footnoteSemibold)
                .foregroundColor(.textWhite)
            Spacer()
        }
    }
}

fileprivate struct SnapshotProposalStatusBarView: View {
    let state: Proposal.State
    let votingEnd: Date

    var body: some View {
        HStack {
            ProposalStatusView(state: state)
            Spacer()
            HStack(spacing: 0) {
                Text("Vote finishes ")
                    .font(.footnoteRegular)
                    .foregroundColor(.textWhite)
                DateView(date: votingEnd,
                         style: .numeric,
                         font: .footnoteRegular,
                         color: .textWhite)
            }
        }
        .padding(10)
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

fileprivate struct SnapshotProposalTimelineView: View {
    private let testDates = [Date.now]
    private let testEvents = ["Snapshot vote created by ", "Discussion started by "]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Timeline")
                .font(.headlineSemibold)
                .foregroundColor(.textWhite)

            ForEach(0..<2) { i in
                HStack(spacing: 2) {
                    //DateView(date: Date("Nov 5, 2022") ?? Date.now)
                    Text("Nov 5, 2022 - ")
                    Text(testEvents[i])
                    IdentityView(user: .test)
                }
                .font(.footnoteRegular)
                .foregroundColor(.textWhite)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            }
        }
    }
}

struct SnapshotProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalView(proposal: .aaveTest, allowShowingDaoInfo: true, navigationTitle: "")
    }
}
