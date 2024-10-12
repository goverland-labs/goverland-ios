//
//  MyDelegatesDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class MyDelegatesDataSource: ObservableObject {
    let appUserId: Address
    @Published var userDelegates: [UserDaoDelegates] = []
    @Published var delegatesCount: Int = 0
    
    @Published var failedToLoadInitialData = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appUserId: Address) {
        self.appUserId = appUserId
    }
    
    func refresh() {
        userDelegates = []
        delegatesCount = 0
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadInitialData()
        userDelegatesCount()
    }
    
    private func loadInitialData() {
        isLoading = true
        APIService.userDelegates(userID: appUserId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] userDelegates, headers in
                self?.userDelegates = userDelegates
            }
            .store(in: &cancellables)
    }
    
    private func userDelegatesCount() {
        for d in self.userDelegates {
            self.delegatesCount += d.delegates.count
        }
    }
    
}
