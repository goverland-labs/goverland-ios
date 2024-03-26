//
//  TopDaoVotersDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Combine

class TopDaoVotersDataSource: TopVotersDataSource<TopVoter> {
    private let daoID: UUID

    init(daoID: UUID) {
        self.daoID = daoID
    }

    convenience init(dao: Dao) {
        self.init(daoID: dao.id)
    }

    override func loadData() {
        APIService.topVoters(id: daoID, limit: 10)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] result, headers in
                guard let `self` = self else { return }
                self.topVoters = result
                self.totalVotingPower = Utils.getTotalVotingPower(from: headers)
                self.total = Utils.getTotal(from: headers)
            }
            .store(in: &cancellables)
    }
}
