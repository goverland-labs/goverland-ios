//
//  MonthlyActiveVotersGraphView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//

import SwiftUI
import Charts

struct MonthlyActiveVotersGraphView: View {
    @StateObject private var dataSource: MonthlyActiveVotersDataSource
    
    init(dao: Dao) {
        let dataSource = MonthlyActiveVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphView(header: "Monthly active users",
                  subheader: "Distinguishing between established and newly acquired user",
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
                    }
                }
            }
            .padding()
            .chartForegroundStyleScale([
                // String name has to be same as in dataSource.chartData
                "Returning Voters": Color.chartBar, "New Voters": Color.primary
            ])
            .chartOverlay { chartProxy in
                GeometryReader { proxy in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    if let date: Date = chartProxy.value(atX: location.x) {
                                        let calendar = Calendar.current
                                        let month = calendar.component(.month, from: date)
                                        let year = calendar.component(.year, from: date)
                                        print(year, month)
//                                        print("--------------")
//                                        
//                                        if let currentNewVoters = dataSource.chartData.first?.data.first(where: { item in
//                                            calendar.component(.year, from: item.year) == year &&
//                                            calendar.component(.month, from: item.month) == month
//                                        }){
//                                            print(currentNewVoters)
//                                        }
                                    }
                                    
                                }
                        )
                }
            }
        }
    }
}

struct MonthlyActiveVotersGraphView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyActiveVotersGraphView(dao: .aave)
    }
}
