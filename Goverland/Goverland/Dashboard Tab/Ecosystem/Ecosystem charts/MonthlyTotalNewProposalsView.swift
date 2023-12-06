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
                    RuleMark(x: .value("Date", Utils.formatDateToMiddleOfMonth(selectedDate)))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: selectedDate <= midDate ? .trailing : .leading,
                            alignment: .center, spacing: 4
                        ) {
                            AnnotationView(date: selectedDate, dataSource: dataSource)
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
    
    // TODO: refactor to remove code duplication
    private struct AnnotationView: View {
        let date: Date
        let dataSource: MonthlyTotalNewProposalsDataSource

        var count: Int {
            dataSource.totalNewProposalsCount(date: date)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(String(Utils.formattedNumber(Double(count))))
                            .font(.title3Regular)
                            .foregroundColor(.textWhite)
                        Text("New proposals")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
                HStack {
                    HStack(spacing: 4) {
                        Text(Utils.monthAndYear(from: date))
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
            }
            .padding(8)
            .background(Color.containerBright)
            .cornerRadius(10)
        }
    }
}

