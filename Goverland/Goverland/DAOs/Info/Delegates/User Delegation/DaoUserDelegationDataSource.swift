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
        guard let selectedChain else { return false }
        return selectedChain.balance >= selectedChain.feeApproximation
    }
    
    var deltaBalance: Double {
        guard let selectedChain else { return 0.0 }
        return selectedChain.feeApproximation - selectedChain.balance
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
        guard let userDelegation else { return }

        let xdaiBalance = userDelegation.chains.gnosis.balance
        let xdaiFee = userDelegation.chains.gnosis.feeApproximation
        let ethBalance = userDelegation.chains.eth.balance
        let ethFee = userDelegation.chains.eth.feeApproximation

        if xdaiFee <= xdaiBalance {
            self.selectedChain = userDelegation.chains.gnosis
        } else if ethFee <= ethBalance {
            self.selectedChain = userDelegation.chains.eth
        } else {
            self.selectedChain = userDelegation.chains.gnosis
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
