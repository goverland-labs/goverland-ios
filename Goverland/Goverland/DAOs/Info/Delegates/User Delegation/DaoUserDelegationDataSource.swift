//
//  DaoUserDelegationDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine
import SwiftDate

class DaoUserDelegationDataSource: ObservableObject, Refreshable {
    let dao: Dao
    let tappedDelegate: User
    
    @Published var userDelegation: DaoUserDelegation?
    
    @Published var failedToLoadInitialData = false
    @Published var filter: DaoDelegateProfileFilter = .activity
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dao: Dao, tappedDelegate: User) {
        self.dao = dao
        self.tappedDelegate = tappedDelegate
    }
    
    func refresh() {
        userDelegation = nil
        failedToLoadInitialData = false
        filter = .activity
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadData()
        //self.userDelegation = .testUserDelegation
    }
    
    private func loadData() {
        isLoading = true
        APIService.daoUserDelegation(daoID: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] userDelegation, _ in
                self?.userDelegation = userDelegation
            }
            .store(in: &cancellables)
    }
}

