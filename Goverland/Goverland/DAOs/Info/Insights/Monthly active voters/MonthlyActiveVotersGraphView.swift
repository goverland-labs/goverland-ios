//
//  MonthlyActiveVotersGraphView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Charts
import SwiftDate

struct MonthlyActiveVotersGraphView: View {
    @StateObject private var dataSource: MonthlyActiveVotersDataSource
    
    init(dao: Dao) {
        let dataSource = MonthlyActiveVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphView(header: "Monthly active voters",
                  subheader: "Month-by-month breakdown of active voters, distinguishing between returning and new voters.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 350,
                  onRefresh: dataSource.refresh)
        {
            MonthlyActiveChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyActiveUsers.isEmpty {
                dataSource.refresh()
            }
        }
    }

    struct MonthlyActiveChart: GraphViewContent {
        @ObservedObject var dataSource: MonthlyActiveVotersDataSource
        @State private var selectedDate: Date? = nil

        var minScaleDate: Date {
            (dataSource.monthlyActiveUsers.first?.date ?? Date()) - 1.months
        }

        var maxScaleDate: Date {
            (dataSource.monthlyActiveUsers.last?.date ?? Date()) + 1.months
        }

        var midDate: Date {
            let count = dataSource.monthlyActiveUsers.count
            if count > 0 {
                return dataSource.monthlyActiveUsers[count/2].date
            } else {
                return Date()
            }
        }

        var body: some View {
            VStack {
                ChartFilters(selectedOption: $dataSource.selectedFilteringOption)
                    .padding(.leading, Constants.horizontalPadding)

                Chart {
                    ForEach(dataSource.chartData, id: \.votersType) { element in
                        ForEach(element.data, id: \.date) { data in
                            BarMark (
                                x: .value("Date", data.date, unit: .month),
                                y: .value("Voters", data.voters)
                            )
                            .foregroundStyle(by: .value("Voters(type)", element.votersType))
                            .foregroundStyle(Color.primaryDim)

                            if let selectedDate {
                                RuleMark(x: .value("Date", Utils.formatDateToStartOfMonth(selectedDate, dayOffset: 15)))
                                    .foregroundStyle(Color.textWhite)
                                    .lineStyle(.init(lineWidth: 1, dash: [2]))
                                    .annotation(
                                        position: selectedDate <= midDate ? .trailing : .leading,
                                        alignment: .center, spacing: 4
                                    ) {
                                        AnnotationView(firstPlaceholderValue: dataSource.returningVoters(date: selectedDate),
                                                       firstPlaceholderTitle: "Returning voters",
                                                       secondPlaceholderValue: dataSource.newVoters(date: selectedDate),
                                                       secondPlaceholderTitle: "New voters",
                                                       description: Utils.shortDateWithoutDay(selectedDate))
                                    }
                            }
                        }
                    }
                }
                .padding()
                .chartXScale(domain: [minScaleDate, maxScaleDate])
                .chartForegroundStyleScale([
                    // String name has to be same as in dataSource.chartData
                    "Returning voters": Color.primaryDim, "New voters": Color.cyan
                ])
                .chartSelected_X_Date($selectedDate, minValue: minScaleDate, maxValue: maxScaleDate)
            }
        }
    }
}
