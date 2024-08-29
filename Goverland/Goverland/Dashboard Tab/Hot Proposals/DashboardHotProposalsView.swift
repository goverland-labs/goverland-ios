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
            } else if dataSource.isLoading && dataSource.proposals.count == 0 { // initial loading
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
                    ForEach(dataSource.proposals.prefix(count)) { proposal in
                        ProposalListItemView(proposal: proposal) {
                            activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                            Tracker.track(.dashHotOpenDao)
                        }
                        .onTapGesture {
                            Tracker.track(.dashHotOpenPrp)
                            path.append(proposal)
                        }
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}
