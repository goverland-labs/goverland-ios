//
//  PublicUserProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicUserProfileActivityView: View {
    @Binding private var path: [PublicUserProfileScreen]
    @StateObject private var dataSource: PublicUserProfileActivityDataSource
    let activeSheetManager: ActiveSheetManager

    init(address: Address,
         activeSheetManager: ActiveSheetManager,
         path: Binding<[PublicUserProfileScreen]>)
    {
        _dataSource = StateObject(wrappedValue: PublicUserProfileActivityDataSource(address: address))
        _path = path
        self.activeSheetManager = activeSheetManager
    }

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var body: some View {
        VStack {
            HStack {
                Text("Votes (\(dataSource.total ?? 0))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                NavigationLink("See all", value: PublicUserProfileScreen.votes)
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.primaryDim)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.votedProposals == nil { // initial loading
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemCondensedView()
                        .padding(.horizontal, 8)
                }
            } else if dataSource.votedProposals?.isEmpty ?? false {
                // User has not voted yet. Message will be displayed in other component.
                Text("")
            } else {
                ForEach(votedProposals.prefix(3)) { proposal in
                    ProposalListItemCondensedView(proposal: proposal) {
                        // TODO: track
//                        Tracker.track(.prfVotesOpenDao)
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    }
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        // TODO: track
//                        Tracker.track(.prfVotesOpenProposal)
                        path.append(.vote(proposal))
                    }
                }
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if votedProposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
}
