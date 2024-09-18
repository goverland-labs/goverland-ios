//
//  TopDaoVotersDistributionDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

class TopDaoVotersDistributionDataSource: ObservableObject, Refreshable {
    let dao: Dao

    var datesFilteringOption: DatesFiltetingOption {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    var distributionFilteringOption: DistributionFilteringOption {
        didSet {
            calculateBins()
        }
    }

    private(set) var vps: [Double]? {
        didSet {
            calculateBins()
        }
    }

    @Published private(set) var bins = [DistributionBin]()

    @Published private(set) var failedToLoadInitialData: Bool = false
    @Published private(set) var isLoading = false
    var cancellables = Set<AnyCancellable>()

    var xValues: [String] {
        guard bins.count >= 4 else {
            return bins.map { String($0.range.lowerBound) }
        }
        return [bins[0].range.lowerBound,
                bins[bins.count / 3].range.lowerBound,
                bins[2 * bins.count / 3].range.lowerBound,
                bins[bins.count - 1].range.lowerBound].map { String($0) }
    }

    private var vpCache: [DatesFiltetingOption: [Double]] = [:]

    init(dao: Dao,
         datesFilteringOption: DatesFiltetingOption,
         distributionFilteringOption: DistributionFilteringOption)
    {
        self.dao = dao
        self.datesFilteringOption = datesFilteringOption
        self.distributionFilteringOption = distributionFilteringOption
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let vpCachedData = vpCache[datesFilteringOption], !invalidateCache {
            logInfo("[App] found vpCache")
            vps = vpCachedData
            return
        }

        if invalidateCache {
            vpCache = [:]
        }

        vps = nil
        bins = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

        loadData()
//
//        let mockVPS = [1, 2, 2.5, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 7, 7.5, 7.8, 10, 10.5, 11, 11.1, 11.2, 11.3, 15, 15, 25, 32, 65, 130, 300, 301]
//        loadMockData(vps: mockVPS)
    }

    func loadMockData(vps: [Double]) {
        logInfo("[App] Load data with filtering option: \(datesFilteringOption)")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.vps = vps
            self.vpCache[datesFilteringOption] = self.vps
        }
    }

    func loadData() {
        isLoading = true
        APIService.allDaoVotersAVP(daoId: dao.id, filteringOption: datesFilteringOption)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] vps, headers in
                guard let self else { return }
                self.vps = vps.sorted().filter { $0 > 0 }
                self.vpCache[datesFilteringOption] = self.vps
            }
            .store(in: &cancellables)
    }

    private func calculateBins() {
        guard let vps else { return }

        switch distributionFilteringOption {
        case .log2:
            self.bins = DistributionMath.calculateLogarithmicBins(values: vps)
        case .squareRoot:
            self.bins = DistributionMath.calculateSquareRootBins(values: vps)
        }
    }
}
