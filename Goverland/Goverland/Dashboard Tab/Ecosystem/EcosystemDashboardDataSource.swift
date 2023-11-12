//
//  EcosystemDashboardDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-12.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import Combine

class EcosystemDashboardDataSource: ObservableObject {
    @Published var periodInDays = 7
    //@Published var charts: EcosystemChart?
    @Published var charts: EcosystemChart = EcosystemChart(
        daos: EcosystemChart.EcosystemChartData(current: "11", previous: "1111"),
        proposals: EcosystemChart.EcosystemChartData(current: "22", previous: "2222"),
        voters: EcosystemChart.EcosystemChartData(current: "33", previous: "3333"),
        votes: EcosystemChart.EcosystemChartData(current: "44", previous: "44444"))
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    func refresh() {
        //charts = nil
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.ecosystemCharts(days: periodInDays)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.charts = data
            }
            .store(in: &cancellables)
    }
}
