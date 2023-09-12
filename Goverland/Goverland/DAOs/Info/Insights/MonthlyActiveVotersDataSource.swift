//
//  MonthlyActiveVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-04.
//

import SwiftUI
import Combine

class MonthlyActiveVotersDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var monthlyActiveUsers: [MonthlyActiveUsers] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    var chartData: [(votersType: String, data: [MonthlyActiveVotersGraphData])] {
        [(votersType: "Returning Voters", data: getReturningVoters()),
         (votersType: "New Voters", data: getNewVoters())]
    }
    
    init(daoID: UUID) {
        self.daoID = daoID
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }
    
    func refresh() {
        monthlyActiveUsers = []
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.monthlyActiveUsers(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.monthlyActiveUsers = data
            }
            .store(in: &cancellables)
    }
    
    struct MonthlyActiveVotersGraphData: Identifiable {
        let id = UUID()
        let date: Date
        let voters: Double
    }

    private func getReturningVoters() -> [MonthlyActiveVotersGraphData] {
        monthlyActiveUsers.map { MonthlyActiveVotersGraphData(date: $0.date, voters: $0.activeUsers) }
    }
    
    private func getNewVoters() -> [MonthlyActiveVotersGraphData] {
        monthlyActiveUsers.map { MonthlyActiveVotersGraphData(date: $0.date, voters: $0.newUsers) }
    }
}
