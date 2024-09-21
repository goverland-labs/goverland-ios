//
//  DistributionMath.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

typealias DistributionBin = (range: Range<Double>, count: Int)

enum DistributionMath {
    // Function to calculate bins using Square Root Choice method
    static func calculateSquareRootBins(values: [Double]) -> [DistributionBin] {
        var bins = [DistributionBin]()
        guard let minValue = values.first, let maxValue = values.last else { return [] }
        let numberOfBins = Int(log(maxValue - minValue) * 3.221 + 1)
        let binWidth = (maxValue - minValue) / Double(numberOfBins)

        var currentIndex = 0
        for i in 0..<numberOfBins {
            let lowerBound = minValue + Double(i) * binWidth
            let upperBound = minValue + Double(i + 1) * binWidth
//            let upperBound = i == numberOfBins - 1 ? Int(ceil(maxValue)) : Int(minValue + Double(i + 1) * binWidth)
            let binRange = lowerBound..<upperBound // Use a half-open range [lowerBound, upperBound)
            var binCount = 0
            // Count how many sorted values fall into the current bin range
            while currentIndex < values.count, valueWithinRange(values[currentIndex], upperBound, i == numberOfBins - 1) {
                binCount += 1
                currentIndex += 1
            }
            bins.append((range: binRange, count: binCount))
        }

        return bins
    }

    // Function to calculate bins using Logarithmic method
    static func calculateLogarithmicBins(values: [Double], base: Double = 2.0) -> [DistributionBin] {
        var bins = [DistributionBin]()
        guard let minValue = values.first, let maxValue = values.last, minValue > 0 else { return [] } // Avoid log(0)
        let minLog = logBase(minValue, base: base)
//        let minLog = max(-1, logBase(minValue, base: base))
        let maxLog = logBase(maxValue, base: base)
        let numberOfBins = Int(ceil(maxLog - minLog))

        logInfo("[App] minLog=\(minLog); maxLog=\(maxLog); numberOfBins=\(numberOfBins)")

        var currentIndex = 0
        for i in 0..<numberOfBins {
            let lowerBound = pow(base, minLog + Double(i))
            let upperBound = pow(base, minLog + Double(i + 1))
//            let upperBound = i == numberOfBins - 1 ? Int(ceil(maxValue)) : Int(pow(base, minLog + Double(i + 1)))
            let binRange = lowerBound..<upperBound // Use a half-open range [lowerBound, upperBound)
            var binCount = 0
            // Count how many sorted values fall into the current logarithmic bin range
            while currentIndex < values.count, valueWithinRange(values[currentIndex], upperBound, i == numberOfBins - 1) {
                binCount += 1
                currentIndex += 1
            }
            bins.append((range: binRange, count: binCount))
        }

        logInfo("[App] log bins: \(bins)")
        return bins
    }

    static private func valueWithinRange(_ value: Double, _ upperBoud: Double, _ closedRange: Bool) -> Bool {
        closedRange ? value <= Double(upperBoud) : value < Double(upperBoud)
    }

    static private func logBase(_ value: Double, base: Double) -> Double {
        return log(value) / log(base)
    }
}