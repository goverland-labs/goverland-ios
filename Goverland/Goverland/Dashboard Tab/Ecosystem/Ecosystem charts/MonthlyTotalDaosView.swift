//
//  MonthlyTotalDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-29.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Charts

struct MonthlyTotalDaosView: View {
    @StateObject private var dataSource: MonthlyTotalDaosDataSource
    
    init() {
        let dataSource = MonthlyTotalDaosDataSource()
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphView(header: "Monthly active DAOs",
                  subheader: "Month-by-month breakdown of active DAOs, distinguishing between returning and new DAOs.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  onRefresh: dataSource.refresh)
        {
            MonthlyTotalDaosChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.monthlyTotalDaos.isEmpty {
                dataSource.refresh()
            }
        }
    }

    struct MonthlyTotalDaosChart: GraphViewContent {
        @StateObject var dataSource: MonthlyTotalDaosDataSource
        @State private var selectedDate: Date? = nil

        var minScaleDate: Date {
            (dataSource.monthlyTotalDaos.first?.date ?? Date())
        }

        var maxScaleDate: Date {
            (dataSource.monthlyTotalDaos.last?.date ?? Date()) + 1
        }

        var midDate: Date {
            let count = dataSource.monthlyTotalDaos.count
            if count > 0 {
                return dataSource.monthlyTotalDaos[count/2].date
            } else {
                return Date()
            }
        }

        var body: some View {
            Chart {
                ForEach(dataSource.chartData, id: \.daosType) { element in
                    ForEach(element.data, id: \.date) { data in
                        BarMark (
                            x: .value("Date", data.date, unit: .month),
                            y: .value("DAOs", data.daos)
                        )
                        .foregroundStyle(by: .value("DAOs(type)", element.daosType))
                        .foregroundStyle(Color.primaryDim)
                        
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
                }
            }
            .padding()
            .chartXScale(domain: [minScaleDate, maxScaleDate])
            .chartForegroundStyleScale([
                // String name has to be same as in dataSource.chartData
                "Returning DAOs": Color.primaryDim, "New DAOs": Color.cyan
            ])
            .chartSelected_X_Date($selectedDate, minValue: minScaleDate, maxValue: maxScaleDate)
        }
    }

    private struct AnnotationView: View {
        let date: Date
        let dataSource: MonthlyTotalDaosDataSource

        var returningDaos: Int {
            dataSource.returningDaos(date: date)
        }

        var newDaos: Int {
            dataSource.newDaos(date: date)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(Utils.decimalNumber(from: newDaos))
                            .font(.title3Regular)
                            .foregroundColor(.textWhite)
                        Text("New daos")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Text(Utils.decimalNumber(from: returningDaos))
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite)
                        Text("Returning daos")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
                
                Text(Utils.monthAndYear(from: date))
                    .font(.captionSemibold)
                    .foregroundColor(.textWhite60)

            }
            .padding(8)
            .background(Color.containerBright)
            .cornerRadius(10)
        }
    }
}

