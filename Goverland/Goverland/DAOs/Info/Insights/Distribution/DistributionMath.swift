//
//  DistributionMath.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

typealias DistributionBin = (range: Range<Int>, count: Int)

enum DistributionMath {
    // Function to calculate bins using Square Root Choice method
    static func calculateSquareRootBins(values: [Double]) -> [DistributionBin] {
        var bins = [DistributionBin]()
        let n = values.count
        let numberOfBins = Int(sqrt(Double(n))) // Square root choice method
        guard let minValue = values.first, let maxValue = values.last, numberOfBins > 0 else { return [] }
        let binWidth = (maxValue - minValue) / Double(numberOfBins)

        logInfo("[App] bin width: \(binWidth)")

        var currentIndex = 0

        func valueWithinRange(_ value: Int, _ upperBoud: Int, _ closedRange: Bool) -> Bool {
            closedRange ? value <= upperBoud : value < upperBoud
        }

        for i in 0..<numberOfBins {
            let lowerBound = Int(minValue + Double(i) * binWidth)
            let upperBound = Int(minValue + Double(i + 1) * binWidth)
            let binRange = lowerBound..<upperBound // Use a half-open range [lowerBound, upperBound)
            var binCount = 0
            // Count how many sorted values fall into the current bin range
            while currentIndex < values.count, valueWithinRange(Int(values[currentIndex]), upperBound, i == numberOfBins - 1) {
                binCount += 1
                currentIndex += 1
            }
            logInfo("[App] add to range \(binRange), count: \(binCount)")
            bins.append((range: binRange, count: binCount))
        }

        return bins
    }

    // Function to calculate bins using Logarithmic method
    static func calculateLogarithmicBins(values: [Double], base: Double = 2.0) -> [DistributionBin] {
        var bins = [DistributionBin]()
        guard let minValue = values.first, let maxValue = values.last, minValue > 0 else { return [] } // Avoid log(0)

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
            while currentIndex < values.count, Int(values[currentIndex]) < Int(upperBound) {
                binCount += 1
                currentIndex += 1
            }

            bins.append((range: binRange, count: binCount))
        }

        return bins
    }
}
