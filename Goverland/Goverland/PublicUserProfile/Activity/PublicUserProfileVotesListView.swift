//
//  PublicUserProfileVotesListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 28.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileVotesListView: View {
    @StateObject private var dataSource: PublicUserProfileActivityDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Binding var path: [PublicUserProfileScreen]
    @State private var selectedVoteIndex: Int? = nil

    init(address: Address) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileActivityDataSource(address: address))
    }

    var body: some View {
        List(0..<dataSource.votedProposals.count, id: \.self, selection: $selectedVoteIndex) { index in
            if index == dataSource.votedProposals.count - 1 { //&& votedProposals.count < dataSource.total ?? 0 {
                //pagination here
            } else {
                let proposal = dataSource.votedProposals[index]
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
        }
        .onChange(of: selectedVoteIndex) { _, _ in
            if let index = selectedVoteIndex, dataSource.votedProposals.count > index {
                Tracker.track(.publicPrfVotesFullOpenProposal)
                let proposal = dataSource.votedProposals[index]
                path.append(.vote(proposal))
            }
        }
        .onAppear {
            selectedVoteIndex = nil
            Tracker.track(.screenPublicProfileVotesFull)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(dataSource.getUserAddress().value)")
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

