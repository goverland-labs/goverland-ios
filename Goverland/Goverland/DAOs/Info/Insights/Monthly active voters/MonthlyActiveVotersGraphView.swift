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
            _MonthlyActiveUsersChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyActiveUsers.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

struct _MonthlyActiveUsersChart: GraphViewContent {
    @ObservedObject var dataSource: MonthlyActiveVotersDataSource
    @State private var selectedDate: Date? = nil

    private var dateAdjustment: DateComponents {
        dataSource.selectedFilteringOption == .oneMonth ? 1.days : 1.months
    }

    private var unit: Calendar.Component {
        dataSource.selectedFilteringOption == .oneMonth ? .day : .month
    }

    private var minScaleDate: Date {
        (dataSource.monthlyActiveUsers.first?.date ?? Date())
    }

    private var maxScaleDate: Date {
        (dataSource.monthlyActiveUsers.last?.date ?? Date()) + dateAdjustment
    }

    private var middleMarkDate: Date {
        dataSource.selectedFilteringOption == .oneMonth ?
            Utils.formatDateToStartOfDay(selectedDate!, hour: 6) :
            Utils.formatDateToStartOfMonth(selectedDate!, day: 15)
    }

    private var midDate: Date {
        let count = dataSource.monthlyActiveUsers.count
        if count > 0 {
            return dataSource.monthlyActiveUsers[count/2].date
        } else {
            return Date()
        }
    }

    private var dateStr: String {
        dataSource.selectedFilteringOption == .oneMonth ?
            Utils.shortDateWithoutTime(selectedDate!) :
            Utils.monthAndYear(selectedDate!)
    }

    var body: some View {
        VStack {
            ChartFilters(selectedOption: $dataSource.selectedFilteringOption)
                .padding(.leading, Constants.horizontalPadding)

            Chart {
                ForEach(dataSource.chartData, id: \.votersType) { element in
                    ForEach(element.data, id: \.date) { data in
                        BarMark (
                            x: .value("Date", data.date, unit: unit),
                            y: .value("Voters", data.voters)
                        )
                        .foregroundStyle(by: .value("Voters(type)", element.votersType))
                        .foregroundStyle(Color.primaryDim)

                        if let selectedDate {
                            RuleMark(x: .value("Date", middleMarkDate))
                                .foregroundStyle(Color.textWhite)
                                .lineStyle(.init(lineWidth: 1, dash: [2]))
                                .annotation(
                                    position: selectedDate <= midDate ? .trailing : .leading,
                                    alignment: .center, 
                                    spacing: 4
                                ) {
                                    AnnotationView(firstPlaceholderValue: dataSource.returningVoters(date: selectedDate),
                                                   firstPlaceholderTitle: "Returning voters",
                                                   secondPlaceholderValue: dataSource.newVoters(date: selectedDate),
                                                   secondPlaceholderTitle: "New voters",
                                                   description: dateStr)
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
