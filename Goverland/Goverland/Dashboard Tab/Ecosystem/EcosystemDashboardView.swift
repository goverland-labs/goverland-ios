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

    private var dataActiveDaos: String {
        return dataSource.charts.daos.current ?? ""
    }
    
    private var dataActiveVoters: String {
        return dataSource.charts.voters.current ?? ""
    }
    
    private var dataCreatedProposals: String {
        return dataSource.charts.proposals.current ?? ""
    }
    
    private var dataTotalVotes: String {
        return dataSource.charts.votes.current ?? ""
    }

    private var metadataActiveDaos: String {
        return dataSource.charts.daos.previous ?? ""
    }
    
    private var metadataActiveVoters: String {
        return dataSource.charts.voters.previous ?? ""
    }

    private var metadataCreatedProposals: String {
        return dataSource.charts.proposals.previous ?? ""
    }
    
    private var metadataTotalVotes: String {
        return dataSource.charts.votes.previous ?? ""
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
            }
            
            HStack {
                BrickView(header: "Active DAOs",
                          data: dataActiveDaos,
                          metadata: metadataActiveDaos,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
                BrickView(header: "Active voters",
                          data: dataActiveVoters,
                          metadata: metadataActiveVoters,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
            }
            
            HStack {
                BrickView(header: "Created proposals",
                          data: dataCreatedProposals,
                          metadata: metadataCreatedProposals,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
                BrickView(header: "Total votes",
                          data: dataTotalVotes,
                          metadata: metadataTotalVotes,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          onRefresh: dataSource.refresh)
            }
        }
        .onAppear() {
            if dataSource.charts == nil {
               // dataSource.refresh()
            }
        }
        .padding([.horizontal, .bottom])
    }
}
