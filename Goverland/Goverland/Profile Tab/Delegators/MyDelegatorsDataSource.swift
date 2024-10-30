//
//  MyDelegatorsDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class MyDelegatorsDataSource: ObservableObject {
    @Published var userDelegators: [UserDaoDelegators] = []
    @Published var delegatorsCount: Int = 0
    
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    init() {}
    
    func refresh() {
        userDelegators = []
        delegatorsCount = 0
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.userDelegators()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] userDelegators, headers in
                self?.userDelegators = userDelegators
            }
            .store(in: &cancellables)
    }
}
