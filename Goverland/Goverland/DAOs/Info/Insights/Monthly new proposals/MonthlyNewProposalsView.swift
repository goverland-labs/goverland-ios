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
                  subheader: nil,
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
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
            Chart {
                ForEach(dataSource.monthlyNewProposals.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Date", dataSource.monthlyNewProposals[i].date, unit: .month),
                        y: .value("New proposals", dataSource.monthlyNewProposals[i].count)
                    )
                    .foregroundStyle(Color.primaryDim)
                }

                if let selectedDate {
                    RuleMark(x: .value("Date", selectedDate))
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
            .chartSelected_X_Date($selectedDate)
        }
    }
    
    private struct AnnotationView: View {
        let date: Date
        let dataSource: MonthlyNewProposalsDataSource

        var count: Int {
            dataSource.newProposalsCount(date: date)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(String(count))
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
