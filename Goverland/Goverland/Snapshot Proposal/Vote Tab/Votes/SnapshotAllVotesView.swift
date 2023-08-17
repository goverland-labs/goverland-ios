//
//  SnapshotAllVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-13.
//

import SwiftUI

struct SnapshotAllVotesView: View {
    let proposal: Proposal
    @StateObject var data: SnapsotVotesDataSource
    
    init(proposal: Proposal) {
        _data = StateObject(wrappedValue: SnapsotVotesDataSource(proposal: proposal))
        self.proposal = proposal
    }
    
    var body: some View {
        VStack {
            if data.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: data)
            } else {
                if data.isLoading {
                    ScrollView {
                        ForEach(0..<5) { _ in
                            ShimmerVoteListItemView()
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
                } else {
                    List(0..<data.votes.count, id: \.self) { index in
                        if index == data.votes.count - 1 && data.hasMore() {
                            ZStack {
                                if !data.failedToLoadMore {
                                    ShimmerProposalListItemView()
                                        .onAppear {
                                            data.loadMore()
                                        }
                                } else {
                                    RetryLoadMoreListItemView(dataSource: data)
                                }
                            }
                        } else {
                            let vote = data.votes[index]
                            VoteListItemView(voter: vote.voter,
                                             votingPower: vote.votingPower,
                                             choice: proposal.choices.count > vote.choice ? proposal.choices[vote.choice] : String(vote.choice),
                                             message: vote.message)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .background(.red)
                    .scrollContentBackground(.hidden)
                    
                }
            }
        }
        .onAppear() {
            data.loadMore()
        }
    }
}

struct SnapshotAllVotesView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotAllVotesView(proposal: .aaveTest)
    }
}
