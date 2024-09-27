//
//  TopDaoVotersDistributionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 16.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts

struct TopDaoVotersDistributionView: View {
    @StateObject private var dataSource: TopDaoVotersDistributionDataSource
    @Binding private var datesFilteringOption: DatesFiltetingOption
    @State private var thresholdFilteringOption: ThresholdFiltetingOption

    init(dao: Dao,
         datesFilteringOption: Binding<DatesFiltetingOption>,
         thresholdFilteringOption: ThresholdFiltetingOption = .oneUsd)
    {
        _datesFilteringOption = datesFilteringOption
        _thresholdFilteringOption = State(wrappedValue: thresholdFilteringOption)

        let dataSource = TopDaoVotersDistributionDataSource(dao: dao,
                                                            datesFilteringOption: datesFilteringOption.wrappedValue,
                                                            thresholdFilteringOption: thresholdFilteringOption)
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var infoDescriptionMarkdown: String {
        guard let daoBins = dataSource.daoBins else { return "" }
        let percentageOfVotersCutted = Utils.percentage(of: daoBins.votersCutted, in: daoBins.votersTotal)
        return """
### This chart illustrates the distribution of voting power, denominated in USD (based on the current token price), over the selected \(datesFilteringOption.localizedName) period.

⚠️ Addresses with an average voting power of less than **1 USD** have been excluded and are not represented in this chart.

- **Total addresses voted**: \(Utils.decimalNumber(from: daoBins.votersTotal))
- **Excluded addresses**: \(Utils.decimalNumber(from: daoBins.votersCutted)) (\(percentageOfVotersCutted))
- **1VP price**: \(Utils.decimalNumber(from: daoBins.vpUsdValue))
"""
//TODO: - **Average total voting power per proposal (USD)**: 22.6M USD
    }

    var body: some View {
        VStack {
            if dataSource.daoBins != nil {
                GraphView(header: "aVP distribution in USD (\(datesFilteringOption.localizedName))",
                          subheader: infoDescriptionMarkdown,
                          isLoading: dataSource.isLoading,
                          failedToLoadInitialData: dataSource.failedToLoadInitialData,
                          height: 350,
                          onRefresh: dataSource.refresh)
                {
                    _TopDaoVotersDistributionChart(dataSource: dataSource, thresholdFilteringOption: $thresholdFilteringOption)
                }
            }
        }
        .onChange(of: datesFilteringOption) { _, newValue in
            withAnimation {
                dataSource.datesFilteringOption = newValue
            }
        }
        .onChange(of: thresholdFilteringOption) { _, newValue in
            withAnimation {
                dataSource.thresholdFilteringOption = newValue
            }
        }
        .onAppear() {
            logInfo("[App] on appear")
            if dataSource.daoBins == nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _TopDaoVotersDistributionChart: GraphViewContent {
    @ObservedObject var dataSource: TopDaoVotersDistributionDataSource
    @Binding var thresholdFilteringOption: ThresholdFiltetingOption
    @State private var selectedBin: String?

    var body: some View {
        VStack {
            ChartFilters(selectedOption: $thresholdFilteringOption)
                .padding(.bottom, 12)

            Chart {
                ForEach(dataSource.bins.indices, id: \.self) { index in
                    if index < dataSource.bins.count {
                        // it crashes when chaning date filtering option, doesn't refresh on time
                        let bin = dataSource.bins[index]
                        BarMark (
                            x: .value("Range", dataSource.xValue(bin)),
                            y: .value("Voters", bin.count)
                        )
                        .foregroundStyle(Color.primaryDim)
                    }
                }

                if let selectedBin {
                    RuleMark(x: .value("Range", selectedBin))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: annotationPositionForBin(selectedBin),
                            alignment: .center, spacing: 4
                        ) {
                            if let bin = dataSource.bins.first(where: { dataSource.xValue($0) == selectedBin }),
                               let total = dataSource.notCuttedVoters
                            {
                                let voters = bin.count
                                let percentage = Utils.percentage(of: voters, in: total)
                                let descriptionSuffix = dataSource.bins.last?.range != bin.range ? "(not inclusive)" : "(inclusive)"
                                let description = "aVP is between\n\(Utils.formattedNumber(bin.range.lowerBound)) USD and \(Utils.formattedNumber(bin.range.upperBound)) USD\n\(descriptionSuffix)"
                                AnnotationView(firstPlaceholderValue: String(voters),
                                               firstPlaceholderTitle: voters == 1 ? "Voter (\(percentage))" : "Voters (\(percentage))",
                                               secondPlaceholderValue: nil,
                                               secondPlaceholderTitle: description,
                                               description: annotationDescription(bin: bin))
                            }
                        }
                }
            }
            .chartXAxis {
                AxisMarks(values: dataSource.xValues) { value in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartXAxisLabel("Average voting power range denominated in USD")
            .chartYAxisLabel("Number of Voters")
            .chartSelected_X_String($selectedBin)
        }
        .padding(.horizontal)
    }

    private func annotationPositionForBin(_ selectedBin: String) -> AnnotationPosition {
        let bins = dataSource.bins.map { dataSource.xValue($0) }
        guard let binIndex = bins.firstIndex(of: selectedBin) else {
            return .trailing
        }
        return binIndex <= bins.count / 2 ? .trailing : .leading
    }

    private func annotationDescription(bin: DistributionBin) -> String {
        guard let daoBins = dataSource.daoBins else { return "" }
        let binPercentage = Utils.percentage(of: bin.totalUsd, in: daoBins.avpUsdTotal)
        return "\(binPercentage) of total aVP"
    }
}
