//
//  PublicUserProfileVotesListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 28.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct PublicUserProfileVotesListView: View {
    @StateObject private var dataSource: PublicUserProfileVotesDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Binding var path: [PublicUserProfileScreen]
    @State private var selectedVoteIndex: Int? = nil

    init(user: User, path: Binding<[PublicUserProfileScreen]>) {
        _dataSource = StateObject(wrappedValue: PublicUserProfileVotesDataSource(user: user))
        _path = path
    }

    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource,
                                        message: "Sorry, we couldn’t load user votes")
            } else if dataSource.isLoading {
                ScrollView {
                    ForEach(0..<7) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, Constants.horizontalPadding)
                    }
                }
                .padding(.top, Constants.horizontalPadding / 2)
            } else {
                List(0..<votedProposals.count, id: \.self, selection: $selectedVoteIndex) { index in
                    if index == votedProposals.count - 1 && dataSource.hasMore() { // pagination
                        ZStack {
                            if !dataSource.failedToLoadMore { // try to paginate
                                ShimmerProposalListItemView()
                                    .padding(.bottom, Constants.horizontalPadding / 2)
                                    .onAppear {
                                        dataSource.loadMore()
                                    }
                            } else { // retry pagination
                                RetryLoadMoreListItemView(dataSource: dataSource)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(Constants.listInsets)
                        .listRowBackground(Color.clear)
                    } else {
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
                }
            }




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
            dataSource.refresh()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(dataSource.user.usernameShort)")
        .listStyle(.plain)
        .scrollIndicators(.hidden)

    }
}
