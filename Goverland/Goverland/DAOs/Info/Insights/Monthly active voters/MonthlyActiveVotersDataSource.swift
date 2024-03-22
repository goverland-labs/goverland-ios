//
//  MonthlyActiveVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-04.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Combine

class MonthlyActiveVotersDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var selectedFilteringOption: ChartFiltetingOption = .oneYear {
        didSet {
            refresh()
        }
    }

    @Published var monthlyActiveUsers: [MonthlyActiveUsers] = []
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    var chartData: [(votersType: String, data: [MonthlyActiveVotersGraphData])] {
        [(votersType: "Returning voters", data: getReturningVoters()),
         (votersType: "New voters", data: getNewVoters())]
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
        loadData()
    }
    
    private func loadData() {
        APIService.monthlyActiveUsers(id: daoID, filteringOption: selectedFilteringOption)
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
        let voters: Int
    }

    private func getReturningVoters() -> [MonthlyActiveVotersGraphData] {
        monthlyActiveUsers.map { MonthlyActiveVotersGraphData(date: $0.date, voters: $0.activeUsers - $0.newUsers) }
    }
    
    private func getNewVoters() -> [MonthlyActiveVotersGraphData] {
        monthlyActiveUsers.map { MonthlyActiveVotersGraphData(date: $0.date, voters: $0.newUsers) }
    }

    func returningVoters(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyActiveUsers.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.activeUsers - data.newUsers)
        }
        return "0"
    }

    func newVoters(date: Date) -> String {
        let date = Utils.formatDateToStartOfMonth(date)
        if let data = monthlyActiveUsers.first(where: { $0.date == date }) {
            return Utils.decimalNumber(from: data.newUsers)
        }
        return "0"
    }
}
