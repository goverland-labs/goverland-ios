//
//  MonthlyTotalNewProposalsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Combine

class MonthlyTotalNewProposalsDataSource: ObservableObject, Refreshable {
    @Published var monthlyTotalNewProposals: [MonthlyTotalNewProposals] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
        
    func refresh() {
        monthlyTotalNewProposals = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.monthlyTotalNewProposals()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.monthlyTotalNewProposals = data
            }
            .store(in: &cancellables)
    }
    
    func totalNewProposalsCount(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyTotalNewProposals.first(where: { $0.date == date }) {
            return Utils.formattedNumber(Double(data.newProposals))
        }
        return "0"
    }
}
