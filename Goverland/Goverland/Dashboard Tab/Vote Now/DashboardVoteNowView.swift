//
//  DashboardVoteNowView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct DashboardVoteNowView: View {
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
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else {
                ForEach((dataSource.proposals ?? []).prefix(3)) { proposal in
                    ProposalListItemView(proposal: proposal) {
                        activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                        // track dao opened like .dashVoteNowOpenDao
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .onTapGesture {
                        // tracker proposal open .dashVoteNowOpenPrp
                        path.append(proposal)
                    }
                }
            }
        }
    }
}
