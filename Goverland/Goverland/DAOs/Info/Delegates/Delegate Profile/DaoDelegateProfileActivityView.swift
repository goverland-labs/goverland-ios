//
//  DaoDelegateProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileActivityView: View {
    let delegated: Bool
    @StateObject private var dataSource: DaoDelegateProfileActivityDataSource

    @State private var selectedVoteIndex: Int?

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(delegateId: Address, delegated: Bool) {
        self.delegated = delegated
        let dataSource = DaoDelegateProfileActivityDataSource(delegateId: delegateId)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else if dataSource.isLoading && dataSource.proposals.isEmpty {
            ForEach(0..<3) { _ in
                ShimmerProposalListItemView()
                    .padding(.horizontal, Constants.horizontalPadding)
            }
        } else {
            List(0..<dataSource.proposals.count, id: \.self, selection: $selectedVoteIndex) { index in
                let proposal = dataSource.proposals[index]
                if index == dataSource.proposals.count - 1 && dataSource.hasMore() {
                    ZStack {
                        if !dataSource.failedToLoadMore {
                            ShimmerProposalListItemView()
                                .onAppear {
                                    dataSource.loadMore()
                                }
                        } else {
                            RetryLoadMoreListItemView(dataSource: dataSource)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(Constants.listInsets)
                    .listRowBackground(Color.clear)
                } else {
                    ProposalListItemView(proposal: proposal, isDelegateVoted: delegated)
                        .listRowSeparator(.hidden)
                        .listRowInsets(Constants.listInsets)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onAppear() {
                if dataSource.proposals.isEmpty {
                    dataSource.refresh()
                }
            }
        }
    }
}
