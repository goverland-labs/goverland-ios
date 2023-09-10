//
//  DaoInsightsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-04.
//

import SwiftUI
import Combine

class DaoInsightsDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var monthlyActiveUsers: [MonthlyActiveUsers]
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
        self.monthlyActiveUsers = []
        //refresh()
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
    
    struct ChampionVoters: Identifiable {
        let id = UUID()
        let date: Date
        let voters: Double
    }
    
    func getExistedVoters() -> [ChampionVoters] {
        var existedVoters: [ChampionVoters] = []
        for i in monthlyActiveUsers {
            existedVoters.append(ChampionVoters.init(date: i.date, voters: i.activeUsers))
        }
        return existedVoters
    }
    
    func getNewVoters() -> [ChampionVoters] {
        var newVoters: [ChampionVoters] = []
        for i in monthlyActiveUsers {
            newVoters.append(ChampionVoters.init(date: i.date, voters: i.activeUsers))
        }
        return newVoters
    }
}
