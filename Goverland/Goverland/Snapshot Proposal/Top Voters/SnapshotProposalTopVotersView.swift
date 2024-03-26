//
//  SnapshotProposalTopVotersView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct SnapshotProposalTopVotersView: View {
    @ObservedObject var dataSource: SnapshotProposalTopVotersDataSource
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    var body: some View {
        TopVotersView(dataSource: dataSource, showFilters: false, horizontalPadding: 0) {
            // TODO: impl            
        }
    }
}
