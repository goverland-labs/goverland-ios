//
//  AllDaoVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-20.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class AllDaoVotersDataSource: ObservableObject, Paginatable, Refreshable {
    let dao: Dao
    let filteringOption: DatesFiltetingOption

    @Published var voters: [TopDaoVoter] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private(set) var nextPage: String?
    private var cancellables = Set<AnyCancellable>()
    
    init(dao: Dao, filteringOption: DatesFiltetingOption) {
        self.dao = dao
        self.filteringOption = filteringOption
    }
    
    func refresh() {
        voters = []
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        nextPage = nil
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.topVoters(id: dao.id, 
                             filteringOption: filteringOption)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                self.voters = result
                self.nextPage = Utils.getNextPage(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        APIService.topVoters(id: dao.id,
                             filteringOption: filteringOption,
                             offset: voters.count)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadMore = true
                }
            } receiveValue: { [weak self] (result, headers) in
                self?.failedToLoadMore = false
                self?.voters.append(contentsOf: result)
                self?.nextPage = Utils.getNextPage(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }
    
    func hasMore() -> Bool {
        return self.nextPage != nil
    }
}
