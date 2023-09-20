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
        GraphView(header: "Monthly active users",
                  subheader: "Month-by-month breakdown of active users, distinguishing between 'old' and newly acquired users",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 300,
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

    struct MonthlyActiveChart: View {
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
                        .foregroundStyle(Color.chartBar)
                        
                        if let selectedDate {
                            RuleMark(x: .value("Date", selectedDate))
                                .foregroundStyle(.primary.opacity(0.2))
                                .lineStyle(.init(lineWidth: 1, dash: [4]))
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
                "Returning voters": Color.chartBar, "New voters": Color.primary
            ])
            .chartOverlay { chartProxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    selectedDate = chartProxy.value(atX: value.location.x, as: Date.self)
                                }
                                .onEnded { _ in
                                    selectedDate = nil
                                }
                        )
                        .onTapGesture(coordinateSpace: .local) { location in
                            selectedDate = chartProxy.value(atX: location.x, as: Date.self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                selectedDate = nil
                            }
                        }
                }
            }
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
            VStack(alignment: .leading) {
                Text(Utils.monthAndYear(from: date))
                    .font(.captionSemibold)
                HStack {
                    Circle()
                        .foregroundColor(Color.chartBar)
                        .frame(width: 4, height: 4)
                    Text("Returning voters: \(returningVoters)")
                        .font(.сaption2Regular)
                }
                HStack {
                    Circle()
                        .foregroundColor(Color.primary)
                        .frame(width: 4, height: 4)
                    Text("New voters: \(newVoters)")
                        .font(.сaption2Regular)
                }
            }
            .padding()
            .background(Color.containerBright)
            .cornerRadius(8)
        }
    }
}

struct MonthlyActiveVotersGraphView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyActiveVotersGraphView(dao: .aave)
    }
}
