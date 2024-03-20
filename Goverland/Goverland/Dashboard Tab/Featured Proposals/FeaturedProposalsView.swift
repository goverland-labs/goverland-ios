//
//  FeaturedProposalsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 20.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

/// At the moment we will always display only one featured proposal
struct FeaturedProposalsView: View {
    @StateObject var dataSource = FeaturedProposalsDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.proposals == nil {
                ForEach(0..<1) { _ in
                    ShimmerProposalListItemView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else {
                ForEach((dataSource.proposals ?? []).prefix(1)) { proposal in
                    ProposalListItemNoElipsisView(proposal: proposal,
                                                  isSelected: false,
                                                  isRead: false,
                                                  isHighlighted: true) {
                        Tracker.track(.dashFeaturedPrpOpenDao)
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .onTapGesture {
                        Tracker.track(.dashFeaturedPrpOpenPrp)
                        path.append(proposal)
                    }
                }
            }
        }
    }
}
