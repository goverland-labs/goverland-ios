//
//  DaoInfoInsightsDaoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-28.
//

import SwiftUI
import Charts

struct DaoInfoInsightsDaoView: View {
    @StateObject var dataSource: DaoInsightsDataSource
    
    init(dao: Dao) {
        let dataSource = DaoInsightsDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                VStack {
                    ZStack {
                        VStack {
                            HStack {
                                Text("Monthly active users")
                                    .font(.title3Semibold)
                                    .foregroundColor(.textWhite)
                                    .padding([.horizontal, .top])
                                Spacer()
                            }
                            
                            Color.clear
                                .frame(height: 200)
                                .padding()
                        }
                        
                        ProgressView()
                            .foregroundColor(Color.textWhite20)
                            .controlSize(.large)
                    }
                }
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding()
                
                Spacer()
                
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else {
                VStack {
                    HStack {
                        Text("Monthly active users")
                            .font(.title3Semibold)
                            .foregroundColor(.textWhite)
                            .padding([.horizontal, .top])
                        Spacer()
                    }
                    
                    let chartData = [
                        (votersType: "Existed Voters", data: dataSource.getExistedVoters()),
                        (votersType: "New Voters", data: dataSource.getNewVoters())
                    ]
                    
                    Chart {
                        ForEach(chartData, id: \.votersType) { element in
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
                        "Existed Voters": Color.chartBar, "New Voters": Color.primary
                    ])
                }
                .background(Color.containerBright)
                .cornerRadius(20)
                .padding()
                
                Spacer()
            }
        }
        .onAppear() {
            Tracker.track(.screenDaoInsights)
            if dataSource.monthlyActiveUsers.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

struct DaoInfoInsightsDaoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoInsightsDaoView(dao: .aave)
    }
}
