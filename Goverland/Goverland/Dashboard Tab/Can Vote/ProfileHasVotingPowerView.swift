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
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            return Array(repeating: .init(.flexible()), count: 2)
        } else {
            return Array(repeating: .init(.flexible()), count: 1)
        }
    }

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.proposals == nil { // initial loading
                LazyVGrid(columns: columns, spacing: 8) {
                    let count = columns.count == 1 ? 3 : 4
                    ForEach(0..<count, id: \.self) { _ in
                        ShimmerProposalListItemView()
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    let count = columns.count == 1 ? 3 : 4
                    ForEach((dataSource.proposals ?? []).prefix(count)) { proposal in
                        ProposalListItemNoElipsisView(proposal: proposal) {
                            activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                            Tracker.track(.dashCanVoteOpenDao)
                        }
                        .onTapGesture {
                            Tracker.track(.dashCanVoteOpenPrp)
                            path.append(proposal)
                        }
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}
