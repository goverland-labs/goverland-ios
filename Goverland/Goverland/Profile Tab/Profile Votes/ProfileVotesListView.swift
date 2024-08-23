//
//  ProfileVotesListView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct ProfileVotesListView: View {
    @Binding var path: [ProfileScreen]
    @StateObject private var dataSource = ProfileVotesDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    @State private var selectedVoteIndex: Int?
    
    var votedProposals: [Proposal] {
        dataSource.votedProposals ?? []
    }
    
    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource,
                                        message: "Sorry, we couldn’t load your votes")
            } else if dataSource.votedProposals?.isEmpty ?? false {
                Text("You have not voted yet")
                    .foregroundStyle(Color.textWhite)
                    .font(.bodyRegular)
                    .padding(Constants.horizontalPadding)
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
                            activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                            Tracker.track(.prfVotesFullOpenDao)
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
                Tracker.track(.prfVotesFullOpenProposal)
                let proposal = dataSource.votedProposals![index]
                path.append(.vote(proposal))
            }
        }
        .onAppear {
            selectedVoteIndex = nil
            Tracker.track(.screenProfileVotesFull)
            if votedProposals.isEmpty {
                dataSource.refresh()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My votes")
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .refreshable {
            dataSource.refresh()
        }
    }
}
