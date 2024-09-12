//
//  DaoDelegateProfileActivitySeeAllView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-12.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct DaoDelegateProfileActivitySeeAllView: View {
    @StateObject var dataSource: DaoDelegateProfileActivityDataSource
    @Environment(\.dismiss) private var dismiss
    
    init(delegateID: Address) {
        _dataSource = StateObject(wrappedValue: DaoDelegateProfileActivityDataSource(delegateID: delegateID))
    }
    
    var body: some View {
        Group {
            if !dataSource.failedToLoadInitialData {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if dataSource.isLoading {
                            ForEach(0..<3) { _ in
                                ShimmerProposalListItemView()
                                    .padding(.horizontal, Constants.horizontalPadding)
                            }
                        } else {
                            ForEach(0..<dataSource.votes.count, id: \.self) { index in
                                if index == dataSource.votes.count - 1 && dataSource.hasMore() {
                                    if !dataSource.failedToLoadMore { // try to paginate
                                        ShimmerProposalListItemView()
                                            .onAppear {
                                                dataSource.loadMore()
                                            }
                                    } else { // retry pagination
                                        RetryLoadMoreListItemView(dataSource: dataSource)
                                    }
                                } else {
                                    if index < dataSource.votes.count {
                                        let vote = dataSource.votes[index]
                                        ProposalListItemView(proposal: vote, isSelected: false, isRead: false) {}
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegates")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Votes")
        .onAppear {
            if dataSource.votes.isEmpty {
                dataSource.refresh()
            }
            // TODO: add tracking
        }
    }
}
