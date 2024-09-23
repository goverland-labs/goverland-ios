//
//  VoteNowListView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct VoteNowListView: View {
    @StateObject var dataSource: VoteNowDataSource
    @Binding var path: NavigationPath
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
                        //Track .voteNowFullOpenDao
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(Constants.listInsets)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _, _ in
            if let index = selectedProposalIndex, let proposals = dataSource.proposals, proposals.count > index {
                path.append(proposals[index])
                // track .voteNowFullOpenPrp
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            // track .screenVoteNowFull
            dataSource.loadFullList()
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
