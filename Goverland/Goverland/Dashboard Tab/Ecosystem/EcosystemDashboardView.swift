//
//  EcosystemDashboardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-12.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct EcosystemDashboardView: View {
    @StateObject private var dataSource: EcosystemDashboardDataSource
    @State private var selectedDuration = 7
    
    init() {
        let dataSource = EcosystemDashboardDataSource()
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        VStack {
            Picker("Duration", selection: $selectedDuration) {
                Text("7 days").tag(7)
                Text("30 days").tag(30)
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            .onAppear() {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.containerBright)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.textWhite)], for: .normal)
            }
            .onChange(of: selectedDuration) { newValue in
                dataSource.periodInDays = newValue
                dataSource.refresh()
            }
            
            HStack {
                BrickView(header: "Active DAOs",
                          data: dataSource.dataActiveDaos,
                          metadata: dataSource.metadataActiveDaos,
                          metadataColor: dataSource.metadataColorForActiveDaos,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
                BrickView(header: "Active voters",
                          data: dataSource.dataActiveVoters,
                          metadata: dataSource.metadataActiveVoters,
                          metadataColor: dataSource.metadataColorForActiveVoters,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
            }
            
            HStack {
                BrickView(header: "Created proposals",
                          data: dataSource.dataCreatedProposals,
                          metadata: dataSource.metadataCreatedProposals,
                          metadataColor: dataSource.metadataColorForCreatedProposals,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
                BrickView(header: "Total votes",
                          data: dataSource.dataTotalVotes,
                          metadata: dataSource.metadataTotalVotes,
                          metadataColor: dataSource.metadataColorForTotalVotes,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
            }
        }
        .padding([.horizontal, .bottom])
        .onAppear() {
            if dataSource.charts == nil {
               dataSource.refresh()
            }
        }
    }
}