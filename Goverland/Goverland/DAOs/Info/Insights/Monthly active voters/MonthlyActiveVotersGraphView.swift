//
//  MonthlyActiveVotersGraphView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
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
        @StateObject var dataSource: MonthlyActiveVotersDataSource
        @State private var selectedDate: Date? = nil

        var minScaleDate: Date {
            (dataSource.monthlyActiveUsers.first?.date ?? Date())
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
                }
            }
            .padding()
            .chartXScale(domain: [minScaleDate, maxScaleDate])
            .chartForegroundStyleScale([
                // String name has to be same as in dataSource.chartData
                "Returning voters": Color.primaryDim, "New voters": Color.red
            ])
            .chartSelected_X_Date($selectedDate)
        }
    }

    private struct AnnotationView: View {
        let date: Date
        let dataSource: MonthlyActiveVotersDataSource

        var returningVoters: Int {
            dataSource.returningVoters(date: date)
        }

        var newVoters: Int {
            dataSource.newVoters(date: date)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(Utils.decimalNumber(from: newVoters))
                            .font(.title3Regular)
                            .foregroundColor(.textWhite)
                        Text("New voters")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Text(Utils.decimalNumber(from: returningVoters))
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite)
                        Text("Returned voters")
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
