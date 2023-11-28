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
    @Published var charts: EcosystemChart?
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    func refresh() {
        charts = nil
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
