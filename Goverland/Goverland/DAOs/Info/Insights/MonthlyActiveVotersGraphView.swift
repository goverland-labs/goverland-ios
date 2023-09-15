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
        @State var votersTappedOnChart: (Int, Int) = (0,0)
        @State var dateTapped: Date? = nil
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
                        
                        if let dateTapped = dateTapped {
                            RuleMark(x: .value("Date", dateTapped))
                                .foregroundStyle(Color.chartBar)
                                .lineStyle(.init(lineWidth: 2, dash: [4]))
                                .annotation(position: .top) {
                                    MonthlyActiveChartAnnotation(returnedUsers: votersTappedOnChart.0,
                                                                 newUsers: votersTappedOnChart.1)
                                }
                        }
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
                                    if let dateOnChart: Date = chartProxy.value(atX: location.x) {
                                        let calendar = Calendar.current
                                        let yearOnChart = calendar.component(.year, from: dateOnChart)
                                        let monthOnChart = calendar.component(.month, from: dateOnChart)
                                        dateTapped = dateOnChart
                                        // get new and returned voters for tapped date
                                        votersTappedOnChart = dataSource.getNumberOfVotersForDate(year: yearOnChart, month: monthOnChart)
                                    }
                                }
                                .onEnded { value in
                                    votersTappedOnChart = (0, 0)
                                    dateTapped = nil
                                }
                        )
                }
            }
        }
    }
}

fileprivate struct MonthlyActiveChartAnnotation: View {
    let returnedUsers: Int
    let newUsers: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text("Returned users: \(returnedUsers)")
            Text("New users: \(newUsers)")
        }
        .frame(width: 150)
        .foregroundColor(.white)
        .font(.footnoteRegular)
        .background {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.containerBright)
                .border(Color.chartBar)
        }
    }
}

struct MonthlyActiveVotersGraphView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyActiveVotersGraphView(dao: .aave)
    }
}
