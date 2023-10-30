//
//  MonthlyNewProposalsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//

import SwiftUI
import Combine

class MonthlyNewProposalsDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var monthlyNewProposals: [MonthlyNewProposals] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }
    
    func refresh() {
        monthlyNewProposals = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.monthlyNewProposals(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.monthlyNewProposals = data
            }
            .store(in: &cancellables)
    }
    
    func newProposalsCount(date: Date) -> Int {
        let date = formatDateToStartOfMonth(date)
        if let data = monthlyNewProposals.first(where: { $0.date == date }) {
            return data.count
        }
        return 0
    }

    private func formatDateToStartOfMonth(_ date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: date)
        components.timeZone = .gmt
        return calendar.date(from: components)!
    }
}
