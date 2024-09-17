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
    var filteringOption: DatesFiltetingOption {
        didSet {
            refresh()
        }
    }

    @Published var vps: [Double]? {
        didSet {
            calculateBins()
        }
    }
    @Published var failedToLoadInitialData: Bool = false
    @Published var isLoading = false
    var cancellables = Set<AnyCancellable>()

    private(set) var bins = [(range: ClosedRange<Int>, count: Int)]()

    var xValues: [String] {
        guard bins.count >= 4 else {
            return bins.map { String($0.range.lowerBound) }
        }
        return [bins[0].range.lowerBound,
                bins[bins.count / 3].range.lowerBound,
                bins[2 * bins.count / 3].range.lowerBound,
                bins[bins.count - 1].range.lowerBound].map { String($0) }
    }

    init(dao: Dao, filteringOption: DatesFiltetingOption) {
        self.dao = dao
        self.filteringOption = filteringOption
    }

    func refresh() {
        vps = nil
        failedToLoadInitialData = false
        isLoading = false
        cancellables = Set<AnyCancellable>()

//        loadData()
        loadMockData()
    }

    func loadMockData() {
        logInfo("[App] Load data with filtering option: \(filteringOption)")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isLoading = false
            self?.vps = [1, 2, 2.5, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6, 7, 7, 7.5, 7.8, 10, 10.5, 11, 11.1, 11.2, 11.3, 15, 15, 25, 32, 65, 130, 300]
        }
    }

    func loadData() {
        isLoading = true
        APIService.allDaoVotersAVP(daoId: dao.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(_): self?.failedToLoadInitialData = true
                }
            } receiveValue: { [weak self] vps, headers in
                self?.vps = vps
            }
            .store(in: &cancellables)
    }

    private func calculateBins(base: Double = 2.0) {
        guard let vps else { return }

        var distribution = [Int: Int]()

        for power in vps {
            // Calculate the logarithmic bin for the current voting power
            let bin = pow(base, floor(log(power) / log(base)))
            distribution[Int(bin), default: 0] += 1
        }

        // Convert the distribution dictionary to an array of ranges and counts
        let sortedBins = distribution.keys.sorted()
        bins = []

        for i in 0..<sortedBins.count {
            let start = sortedBins[i]
            let end = i < sortedBins.count - 1 ? sortedBins[i + 1] - 1 : start
            let range = start...end
            let count = distribution[start] ?? 0
            bins.append((range: range, count: count))
        }
    }
}
