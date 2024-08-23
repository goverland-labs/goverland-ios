//
//  SearchProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct TopProposalsListView: View {
    @StateObject var dataSource: TopProposalsDataSource
    @Binding var path: NavigationPath
    let screenTrackingEvent: TrackingEvent
    let openProposalFromListItemTrackingEvent: TrackingEvent
    let openDaoFromListItemTrackingEvent: TrackingEvent
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var selectedProposalIndex: Int?

    var body: some View {
        Group {
            if dataSource.isLoading && dataSource.proposals.count == 0 {
                ScrollView {
                    ForEach(0..<7) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, Constants.horizontalPadding)
                    }
                }
                .padding(.top, Constants.horizontalPadding / 2)
            } else {
                List(0..<dataSource.proposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                    if index == dataSource.proposals.count - 1 && dataSource.hasMore() {
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
                        .listRowInsets(Constants.listInsets)
                        .listRowBackground(Color.clear)
                    } else {
                        let proposal = dataSource.proposals[index]
                        ProposalListItemView(proposal: proposal) {
                            activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                            Tracker.track(openDaoFromListItemTrackingEvent)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(Constants.listInsets)
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _, _ in
            if let index = selectedProposalIndex, dataSource.proposals.count > index {
                path.append(dataSource.proposals[index])
                Tracker.track(openProposalFromListItemTrackingEvent)
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            Tracker.track(screenTrackingEvent)
            if dataSource.proposals.isEmpty {
                dataSource.refresh()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
