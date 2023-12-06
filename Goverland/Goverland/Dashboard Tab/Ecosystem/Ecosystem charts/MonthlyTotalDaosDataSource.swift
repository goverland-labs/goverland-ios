//
//  MonthlyTotalDaosDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Combine

class MonthlyTotalDaosDataSource: ObservableObject, Refreshable {
    @Published var monthlyTotalDaos: [MonthlyTotalDaos] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    var chartData: [(daosType: String, data: [MonthlyTotalDaosGraphData])] {
        [(daosType: "Returning DAOs", data: getReturningDaos()),
         (daosType: "New DAOs", data: getNewDaos())]
    }
        
    func refresh() {
        monthlyTotalDaos = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.monthlyTotalDaos()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.monthlyTotalDaos = data
            }
            .store(in: &cancellables)
    }
    
    struct MonthlyTotalDaosGraphData: Identifiable {
        let id = UUID()
        let date: Date
        let daos: Int
    }

    private func getReturningDaos() -> [MonthlyTotalDaosGraphData] {
        monthlyTotalDaos.map { MonthlyTotalDaosGraphData(date: $0.date, daos: $0.totalDaos - $0.newDaos) }
    }
    
    private func getNewDaos() -> [MonthlyTotalDaosGraphData] {
        monthlyTotalDaos.map { MonthlyTotalDaosGraphData(date: $0.date, daos: $0.newDaos) }
    }

    func returningDaos(date: Date) -> Int {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyTotalDaos.first(where: { $0.date == date }) {
            return data.totalDaos - data.newDaos
        }
        return 0
    }

    func newDaos(date: Date) -> Int {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyTotalDaos.first(where: { $0.date == date }) {
            return data.newDaos
        }
        return 0
    }
}

