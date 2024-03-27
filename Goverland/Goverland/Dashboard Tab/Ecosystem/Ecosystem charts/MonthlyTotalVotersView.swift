//
//  MonthlyTotalVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-12-05.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts

struct MonthlyTotalVotersView: View {
    @StateObject private var dataSource = MonthlyTotalVotersDataSource()
    
    var body: some View {
        GraphView(header: "Monthly active voters",
                  subheader: "Month-by-month breakdown of active voters, distinguishing between returning and new voters.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        {
            MonthlyTotalVotersChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyTotalVoters.isEmpty {
                dataSource.refresh()
            }
        }
    }

    struct MonthlyTotalVotersChart: GraphViewContent {
        @StateObject var dataSource: MonthlyTotalVotersDataSource
        @State private var selectedDate: Date? = nil

        var minScaleDate: Date {
            (dataSource.monthlyTotalVoters.first?.date ?? Date())
        }

        var maxScaleDate: Date {
            (dataSource.monthlyTotalVoters.last?.date ?? Date()) + 1
        }

        var midDate: Date {
            let count = dataSource.monthlyTotalVoters.count
            if count > 0 {
                return dataSource.monthlyTotalVoters[count/2].date
            } else {
                return Date()
            }
        }

        var body: some View {
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
                                    AnnotationView(firstPlaceholderValue: dataSource.newVoters(date: selectedDate),
                                                   firstPlaceholderTitle: "New voters",
                                                   secondPlaceholderValue: dataSource.returningVoters(date: selectedDate),
                                                   secondPlaceholderTitle: "Returning voters",
                                                   description: Utils.monthAndYear(selectedDate))
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
