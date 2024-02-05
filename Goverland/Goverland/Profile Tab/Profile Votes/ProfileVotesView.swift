//
//  ProfileVotesView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProfileVotesView: View {
    @StateObject private var dataSource = ProfileVotesDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var selectedProposalIndex: Int?

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var body: some View {
        Group {
            if dataSource.isLoading && dataSource.votedProposals == nil { // initial loading
                ScrollView {
                    ForEach(0..<5) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 4)
            } else {
                List(0..<votedProposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                    if index == votedProposals.count - 1 && dataSource.hasMore() { // pagination
                        ZStack {
                            if !dataSource.failedToLoadMore { // try to paginate
                                ShimmerProposalListItemView()
                                    .onAppear {
                                        dataSource.loadMore()
                                    }
                            } else { // retry pagination
                                RetryLoadMoreListItemView(dataSource: dataSource)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                        .listRowBackground(Color.clear)
                    } else {
                        let proposal = votedProposals[index]
                        ProposalListItemView(proposal: proposal,
                                             isSelected: false,
                                             isRead: false) {
                            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
    //                            Tracker.track(openDaoFromListItemTrackingEvent)
                        } menuContent: {
                            ProposalSharingMenu(link: proposal.link, isRead: nil, markCompletion: nil)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
    }
}
