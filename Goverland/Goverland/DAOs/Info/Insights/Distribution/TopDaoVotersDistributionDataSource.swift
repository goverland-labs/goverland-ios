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

enum ThresholdFiltetingOption: Int, FilteringOption {
    case oneUsd = 1
    case tenUsd = 10
    case hundredUsd = 100
    case thousandUsd = 1_000
    case tenThousandUsd = 10_000

    var id: Int {
        self.rawValue
    }

    static var allOptions: [Self] {
        [.oneUsd, .tenUsd, .hundredUsd, .thousandUsd, .tenThousandUsd]
    }

    var localizedName: String {
        "$\(Utils.decimalNumber(from: rawValue))"
    }

    var queryParamValue: String {
        String(rawValue)
    }
}

class TopDaoVotersDistributionDataSource: ObservableObject, Refreshable {
    let dao: Dao

    @Published var datesFilteringOption: DatesFiltetingOption = .oneYear {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published var thresholdFilteringOption: ThresholdFiltetingOption = .oneUsd {
        didSet {
            refresh(invalidateCache: false)
        }
    }

    @Published private(set) var daoBins: DaoAvpBins?
    @Published private(set) var binsCache: [DatesFiltetingOption: [ThresholdFiltetingOption: Dao_AVP_BinsState]] = [:]

    @Published private(set) var failedToLoadInitialData = false
    @Published private(set) var isInitialLoading = false
    @Published private(set) var isAdditionalDataLoading = false
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

    var hasData: Bool {
        if let state = binsCache[datesFilteringOption]?[thresholdFilteringOption], case .empty = state {
            return false
        }
        return !binsCache.isEmpty
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
        "$\(Utils.formattedNumber(bin.range.upperBound))"
    }

    enum Dao_AVP_BinsState {
        case loaded(DaoAvpBins)
        case empty
    }

    init(dao: Dao) {
        self.dao = dao
    }

    func refresh() {
        refresh(invalidateCache: true)
    }

    private func refresh(invalidateCache: Bool) {
        if let binsCachedDataState = binsCache[datesFilteringOption]?[thresholdFilteringOption], !invalidateCache {
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
        isInitialLoading = false
        isAdditionalDataLoading = false
        cancellables = Set<AnyCancellable>()
        
        loadData()
    }

    func loadData() {
        if binsCache.isEmpty {
            isInitialLoading = true
        } else {
            isAdditionalDataLoading = true
        }

        APIService.daoAvpBins(daoId: dao.id,
                              datesFilteringOption: datesFilteringOption,
                              thresholdFilteringOption: thresholdFilteringOption)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isInitialLoading = false
                self.isAdditionalDataLoading = false
                switch completion {
                case .finished: break
                case .failure(_):
                    self.failedToLoadInitialData = true
                    self.binsCache[datesFilteringOption, default: [:]][thresholdFilteringOption] = .empty
                }
            } receiveValue: { [weak self] daoBins, headers in
                guard let self else { return }
                self.daoBins = daoBins
                self.binsCache[datesFilteringOption, default: [:]][thresholdFilteringOption] = .loaded(daoBins)
            }
            .store(in: &cancellables)
    }
}
