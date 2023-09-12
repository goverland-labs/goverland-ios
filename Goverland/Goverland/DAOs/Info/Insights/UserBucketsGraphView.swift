//
//  UserBucketsGraphView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//

import SwiftUI
import Charts

struct UserBucketsGraphView: View {
    @StateObject private var dataSource: UserBucketsDataSource
    
    init(dao: Dao) {
        let dataSource = UserBucketsDataSource(dao: dao)
        _dataSource = StateObject(wrappedValue: dataSource)
    }
    
    var body: some View {
        GraphView(header: "Voting Frequency",
                  subheader: "Based on the number of user votes",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 300,
                  onRefresh: dataSource.refresh)
        {
            UserBucketsChart(dataSource: dataSource)
        }
        .onAppear() {
            if dataSource.userBuckets.isEmpty {
                dataSource.refresh()
            }
        }
    }

    struct UserBucketsChart: View {
        @StateObject var dataSource: UserBucketsDataSource

        var body: some View {
            Chart {
                ForEach(dataSource.userBuckets.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Bucket", dataSource.userBuckets[i].votes),
                        y: .value("Voters", dataSource.userBuckets[i].voters)
                    )
                    .foregroundStyle(Color.chartBar)
                }
            }
            .padding()
        }
    }
}

struct UserBucketsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        UserBucketsGraphView(dao: .aave)
    }
}
