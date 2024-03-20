//
//  ProfileVotesView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct ProfileVotesView: View {
    @Binding var path: [ProfileScreen]
    @StateObject private var dataSource = ProfileVotesDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var body: some View {
        VStack {
            HStack {
                Text("My votes (\(dataSource.total ?? 0))")
                    .font(.subheadlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                NavigationLink("See all", value: ProfileScreen.votes)
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
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else if dataSource.votedProposals?.isEmpty ?? false {
                Text("You have not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(16)
            } else {
                ForEach(votedProposals.prefix(3)) { proposal in
                    ProposalListItemNoElipsisView(
                        proposal: proposal,
                        isSelected: false,
                        isRead: false) {
                            Tracker.track(.prfVotesOpenDao)
                            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                        }
                        .padding(.horizontal, Constants.horizontalPadding)
                        .onTapGesture {
                            Tracker.track(.prfVotesOpenProposal)
                            path.append(.vote(proposal))
                        }
                }
            }
        }
        .padding(.bottom, 16)
        .onAppear {
            if dataSource.votedProposals == nil {
                dataSource.refresh()
            }
        }
    }
}
