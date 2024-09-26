//
//  TopDaoVotersDistributionDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

typealias DistributionBin = (range: Range<Double>, count: Int, totalUsd: Double)

class TopDaoVotersDistributionDataSource: ObservableObject, Refreshable {
    let dao: Dao

    var datesFilteringOption: DatesFiltetingOption {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published private(set) var daoBins: DaoAvpBins?
    @Published private(set) var failedToLoadInitialData = false
    @Published private(set) var isLoading = false
    var cancellables = Set<AnyCancellable>()

    var bins: [DistributionBin] {
        guard let daoBins, daoBins.bins.count > 0 else { return [] }
        var dBins = [DistributionBin]()
        dBins.append((range: 0..<daoBins.bins[0].upperBound, count: daoBins.bins[0].count, totalUsd: daoBins.bins[0].totalAvpUsd))
        for i in 1..<daoBins.bins.count {
            dBins.append((range: daoBins.bins[i-1].upperBound..<daoBins.bins[i].upperBound, count: daoBins.bins[i].count, totalUsd: daoBins.bins[i].totalAvpUsd))
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

    enum Dao_AVP_BinsState {
        case loaded(DaoAvpBins)
        case empty
    }
    private var binsCache: [DatesFiltetingOption: Dao_AVP_BinsState] = [:]

    init(dao: Dao, datesFilteringOption: DatesFiltetingOption) {
        self.dao = dao
        self.datesFilteringOption = datesFilteringOption
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let binsCachedDataState = binsCache[datesFilteringOption], !invalidateCache {
            logInfo("[App] cache found")
            switch binsCachedDataState {
            case .loaded(let bins):
                self.daoBins = bins
                self.failedToLoadInitialData = false
            case .empty:
                self.failedToLoadInitialData = true
                self.daoBins = nil
            }
            return
        }

        if invalidateCache {
            binsCache = [:]
        }

        daoBins = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()
        loadData()

//        loadMockData()
    }

    func loadMockData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if true {
                logInfo("[App] mock loaded")
                let jsonData = Data(mockJson().utf8)
                self.daoBins = try! JSONDecoder().decode(DaoAvpBins.self, from: jsonData)
                self.binsCache[datesFilteringOption] = .loaded(self.daoBins!)
            } else {
                logInfo("[App] mock error")
                self.failedToLoadInitialData = true
                self.binsCache[datesFilteringOption] = .empty
            }
        }
    }

    func loadData() {
        isLoading = true
        APIService.dao_AVP_Bins(daoId: dao.id, filteringOption: datesFilteringOption)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_):
                    guard let self else { return }
                    self.failedToLoadInitialData = true
                    self.binsCache[datesFilteringOption] = .empty
                }
            } receiveValue: { [weak self] daoBins, headers in
                guard let self else { return }
                self.daoBins = daoBins
                self.binsCache[datesFilteringOption] = .loaded(daoBins)
            }
            .store(in: &cancellables)
    }
}

fileprivate func mockJson() -> String {
"""
{
  "vp_usd_value": 10.054,
  "voters_cutted": 1555,
  "voters_total": 10500,
  "avp_usd_total": 123456423,
  "bins": [
    { "upper_bound_usd": 1.0, "count": \(Int.random(in: 1...100)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 2.0, "count": \(Int.random(in: 100...200)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 3.0, "count": \(Int.random(in: 150...250)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 4.0, "count": \(Int.random(in: 200...300)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 5.0, "count": \(Int.random(in: 250...350)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 6.0, "count": \(Int.random(in: 150...300)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 7.0, "count": \(Int.random(in: 100...150)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 8.0, "count": \(Int.random(in: 50...120)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 9.0, "count": \(Int.random(in: 30...80)), "total_avp_usd": 2556 },
    { "upper_bound_usd": 10.0, "count": \(Int.random(in: 1...20)), "total_avp_usd": 2556 }
  ]
}
"""
}
