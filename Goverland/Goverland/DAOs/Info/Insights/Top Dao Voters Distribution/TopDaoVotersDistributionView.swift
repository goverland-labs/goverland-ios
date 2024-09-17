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
    @State private var distributionFilteringOption: DistributionFilteringOption = .square

    init(dao: Dao,
         datesFilteringOption: Binding<DatesFiltetingOption>,
         distributionFilteringOption: DistributionFilteringOption = .square)
    {
        let dataSource = TopDaoVotersDistributionDataSource(dao: dao,
                                                            datesFilteringOption: datesFilteringOption.wrappedValue,
                                                            distributionFilteringOption: distributionFilteringOption)
        _datesFilteringOption = datesFilteringOption
        _distributionFilteringOption = State(wrappedValue: distributionFilteringOption)
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
            _TopDaoVotersDistributionChart(dataSource: dataSource,
                                           distributionFilteringOption: $distributionFilteringOption)
        }
        .onAppear() {
            if dataSource.vps?.isEmpty ?? true {
                dataSource.refresh()
            }
        }
        .onChange(of: datesFilteringOption) { _, newValue in
            dataSource.datesFilteringOption = newValue
        }
        .onChange(of: distributionFilteringOption) { _, newValue in
            dataSource.distributionFilteringOption = newValue
        }
    }
}

fileprivate struct _TopDaoVotersDistributionChart: GraphViewContent {
    @ObservedObject var dataSource: TopDaoVotersDistributionDataSource
    @Binding var distributionFilteringOption: DistributionFilteringOption

    var body: some View {
        VStack {
            ChartFilters(selectedOption: $distributionFilteringOption)
                .padding(.leading, Constants.horizontalPadding)

            Chart {
                ForEach(dataSource.bins.indices, id: \.self) { index in
                    let bin = dataSource.bins[index]
                    BarMark (
                        x: .value("Voting Power Range", "\(Int(bin.range.lowerBound))"),
                        y: .value("Number of Voters", bin.count)
                    )
//                    .foregroundStyle(by: .value("Proposals(type)", element.proposalsType))
                    .foregroundStyle(Color.primaryDim)

//                    if let selectedDate {
//                        RuleMark(x: .value("Date", middleMarkDate))
//                            .foregroundStyle(Color.textWhite)
//                            .lineStyle(.init(lineWidth: 1, dash: [2]))
//                            .annotation(
//                                position: selectedDate <= midDate ? .trailing : .leading,
//                                alignment: .center,
//                                spacing: 4
//                            ) {
//                                AnnotationView(firstPlaceholderValue: dataSource.newProposalsCount(date: selectedDate),
//                                               firstPlaceholderTitle: "New proposals",
//                                               secondPlaceholderValue: dataSource.spamProposalsCount(date: selectedDate),
//                                               secondPlaceholderTitle: "Spam proposals",
//                                               description: dateStr)
//                            }
//                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: dataSource.xValues) { value in
//                    AxisValueLabel {
//                        if let value = value.as(String.self) {
//                            Text(value)
//                                .font(.system(size: 10))
//                                .frame(/*maxWidth: .infinity, */alignment: .leading)
//                        }
//                    }
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartXAxisLabel("Voting Power Range (Log Scale)")
            .chartYAxisLabel("Number of Voters")
//            .chartXScale(type: .log)
//            .chartForegroundStyleScale([
//                // String name has to be same as in dataSource.chartData
//                "New proposals": Color.primaryDim, "Spam proposals": Color.red
//            ])
//            .chartSelected_X_Date($selectedDate, minValue: minScaleDate, maxValue: maxScaleDate)
            .padding()
        }
    }
}
