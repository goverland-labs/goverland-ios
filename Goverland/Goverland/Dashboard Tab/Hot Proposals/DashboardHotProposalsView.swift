//
//  DashboardHotProposalsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.10.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DashboardHotProposalsView: View {
    @StateObject var dataSource = TopProposalsDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading && dataSource.proposals.count == 0 {
                ForEach(0..<3) { _ in
                    ShimmerProposalListItemCondensedView()
                        .padding(.horizontal, Constants.horizontalPadding)
                }
            } else {
                ForEach(dataSource.proposals.prefix(3)) { proposal in
                    ProposalListItemCondensedView(proposal: proposal) {
                        activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                        Tracker.track(.dashHotOpenDao)
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .onTapGesture {
                        Tracker.track(.dashHotOpenPrp)
                        path.append(proposal)
                    }
                }
            }
        }
    }
}
