//
//  ProfileHasVotingPowerView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProfileHasVotingPowerView: View {
    @StateObject var dataSource = ProfileHasVotingPowerDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.proposals == nil {
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemCondensedView()
                        .padding(.horizontal, 12)
                }
            } else {
                ForEach((dataSource.proposals ?? []).prefix(3)) { proposal in
                    ProposalListItemCondensedView(proposal: proposal) {
                        activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                        Tracker.track(.dashCanVoteOpenDao)
                    }
                    .padding(.horizontal, 12)
                    .onTapGesture {
                        Tracker.track(.dashCanVoteOpenPrp)
                        path.append(proposal)
                    }
                }
            }
        }
    }
}
