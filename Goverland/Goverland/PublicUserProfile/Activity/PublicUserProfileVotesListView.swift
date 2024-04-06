//
//  PublicUserProfileVotesListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 28.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileVotesListView: View {
    let user: User
    let votedProposals: [Proposal]
    @Binding var path: [PublicUserProfileScreen]

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @State private var selectedVoteIndex: Int?

    var body: some View {
        List(0..<votedProposals.count, id: \.self, selection: $selectedVoteIndex) { index in
            let proposal = votedProposals[index]
            ProposalListItemView(proposal: proposal,
                                 isSelected: false,
                                 isRead: false) {
                activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                Tracker.track(.publicPrfVotesFullOpenDao)
            } menuContent: {
                ProposalSharingMenu(link: proposal.link)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(Constants.listInsets)
            .listRowBackground(Color.clear)
        }
        .onChange(of: selectedVoteIndex) { _, _ in
            if let index = selectedVoteIndex, votedProposals.count > index {
                Tracker.track(.publicPrfVotesFullOpenProposal)
                let proposal = votedProposals[index]
                path.append(.vote(proposal))
            }
        }
        .onAppear {
            selectedVoteIndex = nil
            Tracker.track(.screenPublicProfileVotesFull)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(user.usernameShort)")
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

