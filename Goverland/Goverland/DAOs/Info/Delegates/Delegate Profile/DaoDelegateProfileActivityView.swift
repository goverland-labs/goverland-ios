//
//  DaoDelegateProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoDelegateProfileActivityView: View {
    @StateObject private var dataSource: DaoDelegateProfileActivityDataSource

    init(delegateID: Address) {
        let dataSource = DaoDelegateProfileActivityDataSource(delegateID: delegateID)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else if dataSource.isLoading && dataSource.votes.isEmpty {
            ForEach(0..<1) { _ in
                ShimmerProposalListItemView()
                    .padding(.horizontal, Constants.horizontalPadding)
            }
        } else {
            List(0..<dataSource.votes.count, id: \.self) { i in
                ProposalListItemView(proposal: dataSource.votes[i], isSelected: false, isRead: false) {}
                    .listRowSeparator(.hidden)
                    .listRowInsets(Constants.listInsets)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onAppear() {
                if dataSource.votes.isEmpty {
                    dataSource.refresh()
                }
            }
        }
    }
}
