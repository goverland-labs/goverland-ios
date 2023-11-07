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
                Text("Loading...")
                    .font(.body)
                    .foregroundColor(.textWhite)
                    .padding()
            } else {
                TopVotePowerVotersGraphView(dataSource: dataSource)
                    .padding(.horizontal)
                    .frame(height: 120)
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
    
    var top10voters: [VotePowerVoter] {
        var topVoters = Array(dataSource.topVotePowerVoters.prefix(10))
        let other: VotePowerVoter = VotePowerVoter(name: Address("Other"), voterPower: 10, voterCount: 10)
        topVoters.append(other)
        return topVoters
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(top10voters, id: \.name.description) { voter in
                    BarMark(
                        x: .value("VotePower", voter.voterPower)
                    )
                    .foregroundStyle(by: .value("Name", voter.name.short))
                }
            }
        }
    }
}

