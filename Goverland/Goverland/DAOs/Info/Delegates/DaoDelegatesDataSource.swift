//
//  DaoDelegatesDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class DaoDelegatesDataSource: ObservableObject, Refreshable, Paginatable {
    let dao: Dao
    
    @Published var delegates: [Delegate] = []
    @Published var total: Int?
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    @Published var searchResultDelegates: [Delegate] = []
    @Published var nothingFound: Bool = false
    private var searchCancellable: AnyCancellable?
    
    init(dao: Dao) {
        self.dao = dao
        searchCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
    }
    
    func refresh() {
        delegates = []
        total = nil
        failedToLoadInitialData = false
        failedToLoadMore = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
//        self.delegates = [.delegateNoDelegated, .delegateAaveChan]
//        self.total = 1
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.daoDelegates(daoID: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] delegates, headers in
                self?.delegates = delegates
                self?.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        // TODO: pagination when api ready
    }
    
    private func performSearch(_ searchText: String) {
        nothingFound = false
        guard searchText != "" else { return }
        
        APIService.daoDelegates(daoID: dao.id, query: searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.nothingFound = true
                }
            } receiveValue: { [weak self] result, headers in
                self?.nothingFound = result.isEmpty
                self?.searchResultDelegates = result
            }
            .store(in: &cancellables)
    }
    
    func retryLoadMore() {
        // This will trigger view update cycle that will trigger `loadMore` function
        self.failedToLoadMore = false
    }
    
    func hasMore() -> Bool {
        guard let total = total else { return true }
        return delegates.count < total
    }
}
