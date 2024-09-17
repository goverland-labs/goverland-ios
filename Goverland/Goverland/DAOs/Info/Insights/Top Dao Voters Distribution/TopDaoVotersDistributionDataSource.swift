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

    typealias Bin = (range: Range<Int>, count: Int)

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

    @Published private(set) var bins = [Bin]()

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

//        loadData()
        loadMockData()
    }

    func loadMockData() {
        logInfo("[App] Load data with filtering option: \(datesFilteringOption)")
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.vps = [1, 2, 2.5, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6, 7, 7, 7.5, 7.8, 10, 10.5, 11, 11.1, 11.2, 11.3, 15, 15, 25, 32, 65, 130, 300]
            self.vpCache[datesFilteringOption] = self.vps
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
                guard let self else { return }
                self.vps = vps.sorted()
                self.vpCache[datesFilteringOption] = self.vps
            }
            .store(in: &cancellables)
    }

    private func calculateBins() {
        switch distributionFilteringOption {
        case .square:
            calculateSquareRootBins()
        case .log:
            calculateLogarithmicBins()
        }
    }

    // Function to calculate bins using Square Root Choice method
    private func calculateSquareRootBins() {
        guard let vps else { return }

        var bins = [Bin]()
        let n = vps.count
        let numberOfBins = Int(sqrt(Double(n))) // Square root choice method
        guard let minValue = vps.first, let maxValue = vps.last, numberOfBins > 0 else { return }
        let binWidth = (maxValue - minValue) / Double(numberOfBins)

        var currentIndex = 0
        for i in 0..<numberOfBins {
            let lowerBound = Int(minValue + Double(i) * binWidth)
            let upperBound = Int(minValue + Double(i + 1) * binWidth)
            let binRange = lowerBound..<upperBound // Use a half-open range [lowerBound, upperBound)
            var binCount = 0
            // Count how many sorted values fall into the current bin range
            while currentIndex < vps.count, Int(vps[currentIndex]) < upperBound {
                binCount += 1
                currentIndex += 1
            }
            bins.append((range: binRange, count: binCount))
        }

        self.bins = bins
    }

    // Function to calculate bins using Logarithmic method
    private func calculateLogarithmicBins(base: Double = 2.0) {
        guard let vps else { return }

        var bins = [Bin]()
        guard let minValue = vps.first, let maxValue = vps.last, minValue > 0 else { return } // Avoid log(0)

        func logBase(_ value: Double, base: Double) -> Double {
            return log(value) / log(base)
        }

        let minLog = logBase(minValue, base: base)
        let maxLog = logBase(maxValue, base: base)
        let numberOfBins = Int(ceil(maxLog - minLog))

        var currentIndex = 0
        for i in 0..<numberOfBins {
            let lowerBound = pow(base, minLog + Double(i))
            let upperBound = pow(base, minLog + Double(i + 1))
            let binRange = Int(lowerBound)..<Int(upperBound) // Use a half-open range [lowerBound, upperBound)
            var binCount = 0
            // Count how many sorted values fall into the current logarithmic bin range
            while currentIndex < vps.count, Int(vps[currentIndex]) < Int(upperBound) {
                binCount += 1
                currentIndex += 1
            }

            bins.append((range: binRange, count: binCount))
        }

        self.bins = bins
    }
}
