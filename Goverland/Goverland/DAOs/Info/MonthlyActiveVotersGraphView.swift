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
        VStack {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else {
                VStack {
                    VStack(spacing: 3) {
                        HStack {
                            Text("Monthly active users")
                                .font(.title3Semibold)
                                .foregroundColor(.textWhite)
                                .padding([.horizontal, .top])
                            Spacer()
                        }
                        
                        HStack {
                            Text("Description Number of Votes Cast")
                                .font(.footnote)
                                .foregroundColor(.textWhite40)
                                .padding([.horizontal])
                            Spacer()
                        }
                    }
                    
                    
                    if dataSource.isLoading {
                        VStack {
                            ProgressView()
                                .foregroundColor(Color.textWhite20)
                                .controlSize(.large)
                        }
                        .frame(height: 200)
                    } else {
                        Chart {
                            ForEach(dataSource.chartData, id: \.votersType) { element in
                                ForEach(element.data, id: \.date) { data in
                                    BarMark (
                                        x: .value("Date", data.date, unit: .month),
                                        y: .value("Voters in K", data.voters)
                                    )
                                    .annotation {
                                        if data.voters == 0 {
                                            Text("0")
                                                .foregroundColor(.textWhite40)
                                                .font(.сaption2Regular)
                                        }
                                    }
                                    .foregroundStyle(by: .value("Voters(type)", element.votersType))
                                    .foregroundStyle(Color.chartBar)
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        .chartForegroundStyleScale([
                            // String name has to be same as in dataSource.chartData
                            "Returning Voters": Color.chartBar, "New Voters": Color.primary
                        ])
                    }
                }
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding()
                
                Spacer()
            }
        }
        .onAppear() {
            //Tracker.track(.screenDaoInsights)
            if dataSource.monthlyActiveUsers.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

struct MonthlyActiveVotersGraphView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyActiveVotersGraphView(dao: .aave)
    }
}
