//
//  MonthlyTotalNewProposalsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts
import SwiftDate

struct MonthlyTotalNewProposalsView: View {
    @StateObject private var dataSource = MonthlyTotalNewProposalsDataSource()
    
    var body: some View {
        GraphView(header: "Monthly new proposals",
                  subheader: "Month-by-month breakdown of new proposals",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        {
            MonthlyTotalProposalsChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyTotalNewProposals.isEmpty {
                dataSource.refresh()
            }
        }
    }
    
    struct MonthlyTotalProposalsChart: GraphViewContent {
        @StateObject var dataSource: MonthlyTotalNewProposalsDataSource
        @State private var selectedDate: Date? = nil
        
        var minScaleDate: Date {
            (dataSource.monthlyTotalNewProposals.first?.date ?? Date()) - 1.months
        }

        var maxScaleDate: Date {
            (dataSource.monthlyTotalNewProposals.last?.date ?? Date()) + 1.months
        }
        
        var midDate: Date {
            let count = dataSource.monthlyTotalNewProposals.count
            if count > 0 {
                return dataSource.monthlyTotalNewProposals[count/2].date
            } else {
                return Date()
            }
        }

        var body: some View {
            Chart {
                ForEach(dataSource.monthlyTotalNewProposals.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Date", dataSource.monthlyTotalNewProposals[i].date, unit: .month),
                        y: .value("New proposals", dataSource.monthlyTotalNewProposals[i].newProposals)
                    )
                    .foregroundStyle(Color.primaryDim)
                }

                if let selectedDate {
                    RuleMark(x: .value("Date", Utils.formatDateToStartOfMonth(selectedDate, day: 15)))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: selectedDate <= midDate ? .trailing : .leading,
                            alignment: .center, spacing: 4
                        ) {
                            AnnotationView(firstPlaceholderValue: dataSource.totalNewProposalsCount(date: selectedDate),
                                           firstPlaceholderTitle: "New proposals",
                                           secondPlaceholderValue: nil,
                                           secondPlaceholderTitle: nil,
                                           description: Utils.monthAndYear(selectedDate))
                        }
                }
            }
            .padding()
            .chartXScale(domain: [minScaleDate, maxScaleDate])
            .chartForegroundStyleScale([
                "New proposals": Color.primaryDim
            ])
            .chartSelected_X_Date($selectedDate, minValue: minScaleDate, maxValue: maxScaleDate)
        }
    }
}

