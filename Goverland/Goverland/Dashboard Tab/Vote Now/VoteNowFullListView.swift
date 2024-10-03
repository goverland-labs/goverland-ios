//
//  VoteNowFullListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct VoteNowFullListView: View {
    @Binding var path: NavigationPath
    @StateObject var dataSource = VoteNowDataSource.fullList
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @State private var selectedProposalIndex: Int?
    
    var proposals: [Proposal] {
        dataSource.proposals ?? []
    }

    var body: some View {
        Group {
            if dataSource.isLoading && dataSource.proposals == nil {
                ScrollView {
                    ForEach(0..<3) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, Constants.horizontalPadding)
                    }
                }
                .padding(.top, Constants.horizontalPadding / 2)
            } else {
                List(0..<proposals.count, id: \.self, selection: $selectedProposalIndex) { index in
                    let proposal = proposals[index]
                    ProposalListItemView(proposal: proposal) {
                        activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                        Tracker.track(.dashVoteNowDaoFromList)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(Constants.listInsets)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Vote Now")
        .refreshable {
            dataSource.refresh()
        }
        .onChange(of: selectedProposalIndex) { _, _ in
            if let index = selectedProposalIndex, let proposals = dataSource.proposals, proposals.count > index {
                path.append(proposals[index])
                Tracker.track(.dashVoteNowPrpFromList)
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            if dataSource.proposals?.isEmpty ?? true {
                dataSource.refresh()
            }
            Tracker.track(.screenDashVoteNowList)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
