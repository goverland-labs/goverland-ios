//
//  TopDaoVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class TopDaoVotersDataSource: TopVotersDataSource<TopDaoVoter> {
    let dao: Dao

    init(dao: Dao) {
        self.dao = dao
    }

    override func loadData() {
        APIService.topDaoVoters(id: dao.id, filteringOption: selectedFilteringOption, limit: 10)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }

                self.topVoters = result
                self.cache[selectedFilteringOption] = self.topVoters

                self.totalVotingPower = Utils.getTotalAvgVotingPower(from: headers)
                self.cacheTotalVP[selectedFilteringOption] = self.totalVotingPower

                self.total = Utils.getTotal(from: headers)
                self.cacheTotal[selectedFilteringOption] = self.total
            }
            .store(in: &cancellables)
    }
}
