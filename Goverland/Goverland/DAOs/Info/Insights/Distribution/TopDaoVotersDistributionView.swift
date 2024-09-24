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

    init(dao: Dao, datesFilteringOption: Binding<DatesFiltetingOption>) {
        let dataSource = TopDaoVotersDistributionDataSource(dao: dao,
                                                            datesFilteringOption: datesFilteringOption.wrappedValue)
        _datesFilteringOption = datesFilteringOption
        _dataSource = StateObject(wrappedValue: dataSource)
    }

    var body: some View {
        GraphView(header: "Average VP distribution",
                  subheader: nil,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 350,
                  onRefresh: dataSource.refresh)
        {
            _TopDaoVotersDistributionChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.daoBins == nil {
                dataSource.refresh()
            }
        }
        .onChange(of: datesFilteringOption) { _, newValue in
            withAnimation {
                dataSource.datesFilteringOption = newValue
            }
        }
    }
}

fileprivate struct _TopDaoVotersDistributionChart: GraphViewContent {
    @ObservedObject var dataSource: TopDaoVotersDistributionDataSource
    @State private var selectedBin: String?

    var body: some View {
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
                            let description = "aVP is between \(bin.range.lowerBound)\nand \(bin.range.upperBound) \(descriptionSuffix)"
                            AnnotationView(firstPlaceholderValue: String(voters),
                                           firstPlaceholderTitle: voters == 1 ? "Voter (\(percentage))" : "Voters (\(percentage))",
                                           secondPlaceholderValue: nil,
                                           secondPlaceholderTitle: description,
                                           description: nil)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .chartXAxis {
            AxisMarks(values: dataSource.xValues) { value in
                AxisValueLabel()
                AxisGridLine()
            }
        }
        .chartXAxisLabel("Voting Power Range denominated in USD")
        .chartYAxisLabel("Number of Voters")
//        .chartForegroundStyleScale([
//            "Voters": Color.primaryDim
//        ])
        .chartSelected_X_String($selectedBin)
    }

    private func annotationPositionForBin(_ selectedBin: String) -> AnnotationPosition {
        let bins = dataSource.bins.map { dataSource.xValue($0) }
        guard let binIndex = bins.firstIndex(of: selectedBin) else {
            return .trailing
        }
        return binIndex <= bins.count / 2 ? .trailing : .leading
    }
}
