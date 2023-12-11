//
//  MonthlyTotalVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-12-05.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Combine

class MonthlyTotalVotersDataSource: ObservableObject, Refreshable {
    @Published var monthlyTotalVoters: [MonthlyTotalVoters] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    var chartData: [(votersType: String, data: [MonthlyTotalVotersGraphData])] {
        [(votersType: "Returning voters", data: getReturningTotalVoters()),
         (votersType: "New voters", data: getNewTotalVoters())]
    }
        
    func refresh() {
        monthlyTotalVoters = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.monthlyTotalVoters()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.monthlyTotalVoters = data
            }
            .store(in: &cancellables)
    }
    
    struct MonthlyTotalVotersGraphData: Identifiable {
        let id = UUID()
        let date: Date
        let voters: Int
    }

    private func getReturningTotalVoters() -> [MonthlyTotalVotersGraphData] {
        monthlyTotalVoters.map { MonthlyTotalVotersGraphData(date: $0.date, voters: $0.totalVoters - $0.newVoters) }
    }
    
    private func getNewTotalVoters() -> [MonthlyTotalVotersGraphData] {
        monthlyTotalVoters.map { MonthlyTotalVotersGraphData(date: $0.date, voters: $0.newVoters) }
    }

    func returningVoters(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyTotalVoters.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.totalVoters - data.newVoters)
        }
        return "0"
    }

    func newVoters(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyTotalVoters.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.newVoters)
        }
        return "0"
    }
}

