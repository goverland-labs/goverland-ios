//
//  SnapshotProposalTopVotersView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct SnapshotProposalTopVotersView: View {
    @StateObject private var dataSource: SnapshotProposalTopVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    init(proposal: Proposal) {
        let dataSource = SnapshotProposalTopVotersDataSource(proposal: proposal)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        TopVotersView(dataSource: dataSource, showFilters: false) {
            // TODO: impl            
        }
    }
}
