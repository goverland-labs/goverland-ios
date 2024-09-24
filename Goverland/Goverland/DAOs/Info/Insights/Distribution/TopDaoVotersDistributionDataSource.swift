//
//  TopDaoVotersDistributionDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

typealias DistributionBin = (range: Range<Double>, count: Int)

class TopDaoVotersDistributionDataSource: ObservableObject, Refreshable {
    let dao: Dao

    var datesFilteringOption: DatesFiltetingOption {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published private(set) var daoBins: Dao_AVP_Bins?
    @Published private(set) var failedToLoadInitialData: Bool = false
    @Published private(set) var isLoading = false
    var cancellables = Set<AnyCancellable>()

    var bins: [DistributionBin] {
        guard let daoBins, daoBins.bins.count > 0 else { return [] }
        var dBins = [DistributionBin]()
        dBins.append((range: 0..<daoBins.bins[0].upperBound, count: daoBins.bins[0].count))
        for i in 1..<daoBins.bins.count {
            dBins.append((range: daoBins.bins[i-1].upperBound..<daoBins.bins[i].upperBound, count: daoBins.bins[i].count))
        }
        return dBins
    }

    var notCuttedVoters: Int? {
        guard let daoBins else { return nil }
        return daoBins.votersTotal - daoBins.votersCutted
    }

    var xValues: [String] {
        guard bins.count >= 5 else {
            return bins.map { xValue($0) }
        }
        return [xValue(bins[0]),
                xValue(bins[bins.count / 4]),
                xValue(bins[2 * bins.count / 4]),
                xValue(bins[3 * bins.count / 4]),
                xValue(bins[bins.count - 1])]
    }

    func xValue(_ bin: DistributionBin) -> String {
        Utils.formattedNumber(bin.range.upperBound)
    }

    private var binsCache: [DatesFiltetingOption: Dao_AVP_Bins] = [:]

    init(dao: Dao, datesFilteringOption: DatesFiltetingOption) {
        self.dao = dao
        self.datesFilteringOption = datesFilteringOption
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let binsCachedData = binsCache[datesFilteringOption], !invalidateCache {
            logInfo("[App] found vpCache")
            daoBins = binsCachedData
            return
        }

        if invalidateCache {
            binsCache = [:]
        }

        daoBins = nil
//        bins = []
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
//        loadData()

        loadMockData()
    }

    func loadMockData() {
        logInfo("[App] Load data with filtering option: \(datesFilteringOption)")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            let jsonData = Data(mockJson.utf8)
            self.daoBins = try! JSONDecoder().decode(Dao_AVP_Bins.self, from: jsonData)
            self.binsCache[datesFilteringOption] = self.daoBins
        }
    }

    func loadData() {
        isLoading = true
        APIService.dao_AVP_Bins(daoId: dao.id, filteringOption: datesFilteringOption)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] daoBins, headers in
                guard let self else { return }
                self.daoBins = daoBins
                self.binsCache[datesFilteringOption] = self.daoBins
            }
            .store(in: &cancellables)
    }
}

fileprivate let mockJson = """
{
  "vp_usd_value": 10.054,
  "voters_cutted": 1555,
  "voters_total": 10500,
  "bins": [
    { "upper_bound": 1.0, "count": 10 },
    { "upper_bound": 2.0, "count": 20 },
    { "upper_bound": 3.0, "count": 30 },
    { "upper_bound": 4.0, "count": 40 },
    { "upper_bound": 5.0, "count": 50 },
    { "upper_bound": 6.0, "count": 45 },
    { "upper_bound": 7.0, "count": 35 },
    { "upper_bound": 8.0, "count": 25 },
    { "upper_bound": 9.0, "count": 15 },
    { "upper_bound": 10.0, "count": 10 }
  ]
}
"""
