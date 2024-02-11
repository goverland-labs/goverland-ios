//
//  EcosystemDashboardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-12.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct EcosystemDashboardView: View {
    @StateObject private var dataSource = EcosystemDashboardDataSource.shared
    @State private var selectedDuration = 7

    var body: some View {
        VStack {
            Picker("Duration", selection: $selectedDuration) {
                Text("7 days").tag(7)
                Text("30 days").tag(30)
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            .onChange(of: selectedDuration) { _, newValue in
                dataSource.periodInDays = newValue
                dataSource.refreshWithCache()
            }
            
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.isLoading {
                HStack {
                    ShimmerBrickView()
                    ShimmerBrickView()
                }
                
                HStack {
                    ShimmerBrickView()
                    ShimmerBrickView()
                }
            } else {
                HStack {
                    BrickView(header: "Active DAOs",
                              description: "Number of DAOs that created proposal(s) on Snapshot in the selected period.",
                              data: dataSource.dataActiveDaos,
                              metadata: dataSource.metadataActiveDaos,
                              metadataColor: dataSource.metadataColorForActiveDaos,
                              isLoading: dataSource.isLoading,
                              failedToLoadInitialData: dataSource.failedToLoadInitialData,
                              onRefresh: dataSource.refresh)
                    BrickView(header: "Active voters", 
                              description: "Number of unique voters on Snapshot participating in the selected period.",
                              data: dataSource.dataActiveVoters,
                              metadata: dataSource.metadataActiveVoters,
                              metadataColor: dataSource.metadataColorForActiveVoters,
                              isLoading: dataSource.isLoading,
                              failedToLoadInitialData: dataSource.failedToLoadInitialData,
                              onRefresh: dataSource.refresh)
                }
                
                HStack {
                    BrickView(header: "Created proposals", 
                              description: "Number of proposals created by DAOs on Snapshot in the selected period.",
                              data: dataSource.dataCreatedProposals,
                              metadata: dataSource.metadataCreatedProposals,
                              metadataColor: dataSource.metadataColorForCreatedProposals,
                              isLoading: dataSource.isLoading,
                              failedToLoadInitialData: dataSource.failedToLoadInitialData,
                              onRefresh: dataSource.refresh)
                    BrickView(header: "Total votes", 
                              description: "Number of votes across all proposals on Snapshot in the selected period.",
                              data: dataSource.dataTotalVotes,
                              metadata: dataSource.metadataTotalVotes,
                              metadataColor: dataSource.metadataColorForTotalVotes,
                              isLoading: dataSource.isLoading,
                              failedToLoadInitialData: dataSource.failedToLoadInitialData,
                              onRefresh: dataSource.refresh)
                }
            }
        }
        .padding(.horizontal, 8)
    }
}
