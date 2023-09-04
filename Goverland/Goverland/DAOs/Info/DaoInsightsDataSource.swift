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
    
    @Published var graph: [Graph]
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(daoID: UUID) {
        self.daoID = daoID
        self.graph = []
        refresh()
    }
    
    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }
    
    func refresh() {
        graph = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.daoInsights(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                print("------------- \(completion)")
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] graph, headers in
                print("------------- \(graph)")
                self?.graph = graph
            }
            .store(in: &cancellables)
    }
}
