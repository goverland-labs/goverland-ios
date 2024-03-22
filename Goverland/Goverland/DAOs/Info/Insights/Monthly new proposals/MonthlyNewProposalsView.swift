//
//  MonthlyNewProposalsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-30.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Charts
import SwiftDate

struct MonthlyNewProposalsView: View {
    @StateObject private var dataSource: MonthlyNewProposalsDataSource
    
    init(dao: Dao) {
        let dataSource = MonthlyNewProposalsDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphView(header: "Monthly new proposals",
                  subheader: "Amount of proposals created in this DAO monthly.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 350,
                  onRefresh: dataSource.refresh)
        {
            MonthlyNewProposalsChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyNewProposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
    
    struct MonthlyNewProposalsChart: GraphViewContent {
        @StateObject var dataSource: MonthlyNewProposalsDataSource
        @State private var selectedDate: Date? = nil
        
        var minScaleDate: Date {
            (dataSource.monthlyNewProposals.first?.date ?? Date()) - 1.months
        }

        var maxScaleDate: Date {
            (dataSource.monthlyNewProposals.last?.date ?? Date()) + 1.months
        }
        
        var midDate: Date {
            let count = dataSource.monthlyNewProposals.count
            if count > 0 {
                return dataSource.monthlyNewProposals[count/2].date
            } else {
                return Date()
            }
        }

        var body: some View {
            VStack {
                ChartFilters(selectedOption: $dataSource.selectedFilteringOption)
                    .padding(.leading, Constants.horizontalPadding)

                Chart {
                    ForEach(dataSource.chartData, id: \.proposalsType) { element in
                        ForEach(element.data, id: \.date) { data in
                            BarMark (
                                x: .value("Date", data.date, unit: .month),
                                y: .value("Proposals", data.proposals)
                            )
                            .foregroundStyle(by: .value("Proposals(type)", element.proposalsType))
                            .foregroundStyle(Color.primaryDim)
                        }

                        if let selectedDate {
                            RuleMark(x: .value("Date", Utils.formatDateToMiddleOfMonth(selectedDate)))
                                .foregroundStyle(Color.textWhite)
                                .lineStyle(.init(lineWidth: 1, dash: [2]))
                                .annotation(
                                    position: selectedDate <= midDate ? .trailing : .leading,
                                    alignment: .center, spacing: 4
                                ) {
                                    AnnotationView(firstPlaceholderValue: dataSource.newProposalsCount(date: selectedDate),
                                                   firstPlaceholderTitle: "New proposals",
                                                   secondPlaceholderValue: dataSource.spamProposalsCount(date: selectedDate),
                                                   secondPlaceholderTitle: "Spam proposals",
                                                   description: Utils.monthAndYear(from: selectedDate))
                                }
                        }
                    }
                }
                .padding()
                .chartXScale(domain: [minScaleDate, maxScaleDate])
                .chartForegroundStyleScale([
                    // String name has to be same as in dataSource.chartData
                    "New proposals": Color.primaryDim, "Spam proposals": Color.red                    
                ])
                .chartSelected_X_Date($selectedDate, minValue: minScaleDate, maxValue: maxScaleDate)
            }
        }
    }
}
