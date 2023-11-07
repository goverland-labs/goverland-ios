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
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    @State private var selectedProposalIndex: Int?

    var body: some View {
        Group {
            if dataSource.isLoading && dataSource.proposals.count == 0 {
                ScrollView {
                    ForEach(0..<5) { _ in
                        ShimmerProposalListItemCondensedView()
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 4)
            } else {
                List(0..<dataSource.proposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                    if index == dataSource.proposals.count - 1 && dataSource.hasMore() {
                        ZStack {
                            if !dataSource.failedToLoadMore { // try to paginate
                                ShimmerProposalListItemCondensedView()
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
                        let proposal = dataSource.proposals[index]
                        ProposalListItemCondensedView(proposal: proposal) {
                            activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                            Tracker.track(openDaoFromListItemTrackingEvent)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _ in
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
