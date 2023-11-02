//
//  SuccessfulProposalsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//

import SwiftUI
import Combine

class SuccessfulProposalsDataSource: ObservableObject, Refreshable {
    private let daoID: UUID
    
    @Published var successfulProposals: SuccessfulProposals?
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
        successfulProposals = nil
        failedToLoadInitialData = false
        isLoading = true
        cancellables = Set<AnyCancellable>()
        loadInitialData()
    }
    
    private func loadInitialData() {
        APIService.successfulProposals(id: daoID)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] data, headers in
                self?.successfulProposals = data
            }
            .store(in: &cancellables)
    }
}
