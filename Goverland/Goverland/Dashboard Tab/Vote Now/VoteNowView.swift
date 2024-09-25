//
//  VoteNowView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct VoteNowView: View {
    @StateObject var dataSource = VoteNowDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    
    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.proposals == nil { // initial loading
                ForEach(0..<1) { _ in
                    ShimmerProposalListItemView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else {
                ForEach((dataSource.proposals ?? []).prefix(3)) { proposal in
                    ProposalListItemView(proposal: proposal) {
                        activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                        Tracker.track(.dashVoteNowOpenDao)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .onTapGesture {
                        Tracker.track(.dashVoteNowOpenPrp)
                        path.append(proposal)
                    }
                }
            }
        }
    }
}
