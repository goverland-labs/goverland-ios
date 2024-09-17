//
//  SnapshotProposalTopVotersView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct SnapshotProposalTopVotersView: View {
    @Binding var filteringOption: DatesFiltetingOption
    @ObservedObject var dataSource: SnapshotProposalTopVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Top 10 voters by VP")
                    .font(.headlineSemibold)
                    .foregroundStyle(Color.textWhite)
                Spacer()
            }

            TopVotersView(filteringOption: $filteringOption, dataSource: dataSource, showFilters: false, horizontalPadding: 0) {
                activeSheetManager.activeSheet = .proposalVoters(dataSource.proposal)
            }
        }
    }
}
