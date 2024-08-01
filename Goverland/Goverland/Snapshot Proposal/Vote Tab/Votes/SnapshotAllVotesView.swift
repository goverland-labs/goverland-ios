//
//  SnapshotAllVotesView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-13.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct SnapshotAllVotesView: View {
    let proposal: Proposal

    var body: some View {
        if proposal.privacy == .shutter && proposal.state == .active {
            // Votes are encrypted
            _SnapshotAllVotesView<String>(proposal: proposal)
        } else {
            switch proposal.type {
            case .basic, .singleChoice:
                _SnapshotAllVotesView<Int>(proposal: proposal)
            case .approval, .rankedChoice:
                _SnapshotAllVotesView<[Int]>(proposal: proposal)
            case .weighted, .quadratic:
                _SnapshotAllVotesView<[String: Double]>(proposal: proposal)
            }
        }
    }
}

fileprivate struct _SnapshotAllVotesView<ChoiceType: Decodable>: View {
    let proposal: Proposal
    @StateObject private var data: SnapsotVotesDataSource<ChoiceType>
    @Environment(\.dismiss) private var dismiss
    
    private var searchPrompt: String {
        return "Search for \(data.totalVotes) votes by name or address"
    }

    init(proposal: Proposal) {
        self.proposal = proposal
        _data = StateObject(wrappedValue: SnapsotVotesDataSource<ChoiceType>(proposal: proposal))
    }
    
    var body: some View {
        Group {
            if data.searchText == "" {
                if data.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: data, message: "Sorry, we couldn’t load the votes list")
                } else {
                    if data.isLoading {
                        List(0..<7, id: \.self) { _ in
                            ShimmerVoteListItemView()
                                .padding([.top, .bottom])
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    } else {
                        List(0..<data.votes.count, id: \.self) { index in
                            if index == data.votes.count - 1 && data.hasMore() {
                                if !data.failedToLoadMore {
                                    ShimmerVoteListItemView()
                                        .padding([.top, .bottom])
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                        .onAppear {
                                            data.loadMore()
                                        }
                                } else {
                                    RetryLoadMoreListItemView(dataSource: data) .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                }
                            } else {
                                let vote = data.votes[index]
                                VoteListItemView(proposal: proposal, vote: vote)
                                    .padding([.top, .bottom])
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        if data.nothingFound {
                            Text("Nothing found")
                                .font(.body)
                                .foregroundStyle(Color.textWhite)
                                .padding(.top, 16)
                        } else if data.searchResultVotes.isEmpty { // initial searching
                            ForEach(0..<7) { _ in
                                ShimmerVoteListItemView()
                                    .padding([.top, .bottom])
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                        } else {
                            ForEach(data.searchResultVotes) { vote in
                                VoteListItemView(proposal: proposal, vote: vote)
                                    .padding([.top, .bottom])
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear() {
            data.refresh()
            Tracker.track(.screenSnpVoters)
        }
        .searchable(text: $data.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Votes")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.textWhite)
                }
            }
        }
    }
}
