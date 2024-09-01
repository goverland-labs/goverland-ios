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
    let delegate: User
    
    @Published var userDelegation: DaoUserDelegation?
    @Published var selectedChain: Chain?
    
    @Published var failedToLoadInitialData = false
    @Published var filter: DaoDelegateProfileFilter = .activity
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var isEnoughBalance: Bool {
        selectedChain?.balance ?? 0 >= selectedChain?.feeApproximation ?? 0
    }
    
    var deltaBalance: Double {
        (selectedChain?.feeApproximation ?? 0) - (selectedChain?.balance ?? 0)
    }
    
    init(dao: Dao, delegate: User) {
        self.dao = dao
        self.delegate = delegate
    }
    
    func refresh() {
        userDelegation = nil
        failedToLoadInitialData = false
        filter = .activity
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadData()
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
                self?.assignPreferredChain()
            }
            .store(in: &cancellables)
    }
    
    private func assignPreferredChain() {
        if let delegation = self.userDelegation {
            let gnsBalance = delegation.chains.gnosis.balance
            let gnsFee = delegation.chains.gnosis.feeApproximation
            let ethBalance = delegation.chains.eth.balance
            let ethFee = delegation.chains.eth.feeApproximation
            
            if gnsFee <= gnsBalance {
                self.selectedChain = delegation.chains.gnosis
            } else if ethFee <= ethBalance {
                self.selectedChain = delegation.chains.eth
            } else {
                self.selectedChain = delegation.chains.gnosis
            }
        }
    }
    
    func prepareSplitDelegation(splitModel: UserDelegationSplitViewModel) {
        // TODO: implement proper logic
        var requestDelegates = [DaoUserDelegationRequest.RequestDelegate]()
        for (index, delegate) in splitModel.delegates.enumerated() {
            let powerPercent: Double = splitModel.percentage(for: index)
            requestDelegates.append(
                DaoUserDelegationRequest.RequestDelegate(address: delegate.user.address.value,
                                                         percentOfDelegated: powerPercent)
            )
        }
        
        // TODO: add expiration date logic
        let request = DaoUserDelegationRequest(chainId: selectedChain!.id, delegates: requestDelegates, expirationDate: nil)
        
        logInfo("[App] DaoUserDelegationRequest: \(request)")
        
        APIService.daoPrepareSplitDelegation(daoId: dao.id, request: request)
            .sink { _ in
                // TODO: block Confirm button while request is executing
            } receiveValue: { [weak self] preparedData, _ in
                // TODO: implement proper logic
                logInfo("[App] prepared data: \(preparedData)")
            }
            .store(in: &cancellables)
    }
}
