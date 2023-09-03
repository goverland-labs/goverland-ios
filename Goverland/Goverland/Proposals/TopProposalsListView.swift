//
//  SearchProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//

import SwiftUI

struct TopProposalsListView: View {
    @StateObject var dataSource: TopProposalDataSource
    @Binding var path: NavigationPath
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
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12))
                        .listRowBackground(Color.clear)
                    } else {
                        let proposal = dataSource.proposals[index]
                        ProposalListItemCondensedView(proposal: proposal) {
                            activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                            Tracker.track(.searchPrpOpenDaoFromCard)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _ in
            if let index = selectedProposalIndex, dataSource.proposals.count > index {
                path.append(dataSource.proposals[index])
                Tracker.track(.searchPrpOpenFromCard)
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            Tracker.track(.screenSearchPrp)
            if dataSource.proposals.isEmpty {
                dataSource.refresh()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
