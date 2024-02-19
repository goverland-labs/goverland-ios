//
//  TopVotePowerVotersView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-07.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import Charts

struct TopVotePowerVotersView: View {
    @StateObject private var dataSource: TopVotePowerVotersDataSource
    
    init(dao: Dao) {
        let dataSource = TopVotePowerVotersDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Top 10 voters by average VP")
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                    .padding([.top, .horizontal])
                Spacer()
            }
            
            if dataSource.failedToLoadInitialData {
                RefreshIcon {
                    dataSource.refresh()
                }
            } else if dataSource.topVotePowerVoters.isEmpty {
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                    .frame(height: 120)
            } else {
                TopVotePowerVotersGraphView(dataSource: dataSource)
                    .padding()
            }
        }
        .onAppear {
            if dataSource.topVotePowerVoters.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct TopVotePowerVotersGraphView: View {
    @StateObject var dataSource: TopVotePowerVotersDataSource
    private let barColors: [Color] = [.primaryDim, .yellow, .purple, .orange, .blue, .red, .teal, .green, .red, .cyan, .secondaryContainer]
    
    var body: some View {
        VStack {
            Chart(dataSource.top10votersGraphData) { voter in
                BarMark(
                    x: .value("VotePower", voter.voterPower)
                )
                .foregroundStyle(by: .value("Name", voter.name.short))
            }
        }
        .frame(height: 100)
        .chartXAxis(.hidden)
        .chartLegend(spacing: 20)
        .chartXScale(domain: 0...(dataSource.totalVotingPower ?? 0)) // expands the bar to fill the entire width of the view
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .chartForegroundStyleScale(domain: dataSource.top10votersGraphData.compactMap({ voter in voter.name.short}),
                                   range: barColors) // assigns colors to the segments of the bar
    }
}
