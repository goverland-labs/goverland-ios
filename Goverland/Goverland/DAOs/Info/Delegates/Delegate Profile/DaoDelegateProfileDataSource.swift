//
//  DaoDelegateProfileDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

enum DaoDelegateProfileFilter: Int, FilterOptions {
    case activity = 0
    case about
    case insights

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .about:
            return "About"
        case .insights:
            return "Insights"
        }
    }
}

class DaoDelegateProfileDataSource: ObservableObject, Refreshable {
    let dao: Dao
    let delegate: Delegate
    
    @Published var delegateProfile: DelegateProfile?
    @Published var failedToLoadInitialData = false
    @Published var filter: DaoDelegateProfileFilter = .activity
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dao: Dao, delegate: Delegate) {
        self.dao = dao
        self.delegate = delegate
    }
    
    func refresh() {
        delegateProfile = nil
        failedToLoadInitialData = false
        filter = .activity
        isLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadMOCKdata()
        //loadData()
    }
    
    private func loadMOCKdata() {
        self.isLoading = true
        let mockDP = DelegateProfile(dao: .aave,
                                     votingPower: DelegateProfile.VotingPower(symbol: "UNI", power: 43.1),
                                     chains: [.etherium, .gnosis],
                                     delegates: [.delegateAaveChan, .delegateFlipside],
                                     expirationDate: "2025-07-04T11:35:17Z")
        self.delegateProfile = mockDP
        self.isLoading = false
    }
    
    private func loadData() {
        isLoading = true
        APIService.daoDelegateProfile(daoID: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] delegateProfile, _ in
                self?.delegateProfile = delegateProfile
            }
            .store(in: &cancellables)
    }
}

