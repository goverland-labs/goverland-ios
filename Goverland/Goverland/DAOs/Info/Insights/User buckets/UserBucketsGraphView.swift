//
//  UserBucketsGraphView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-11.
//  Copyright © Goverland Inc. All rights reserved.
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
        GraphView(header: "Voting frequency",
                  subheader: "Categorizing voters into distinct 'buckets' based on the number of user votes.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
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
    
    struct UserBucketsChart: GraphViewContent {
        @StateObject var dataSource: UserBucketsDataSource
        @State private var selectedBucket: String?
        
        var body: some View {
            Chart {
                ForEach(dataSource.userBuckets.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Bucket", dataSource.userBuckets[i].votes),
                        y: .value("Voters", dataSource.userBuckets[i].voters)
                    )
                    .foregroundStyle(Color.primaryDim)
                }
                
                if let selectedBucket {
                    RuleMark(x: .value("Bucket", selectedBucket))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: annotationPositionForBucket(bucket: selectedBucket),
                            alignment: .center, spacing: 4
                        ) {
                            AnnotationView(bucket: selectedBucket, dataSource: dataSource)
                        }
                }
            }
            .padding()
            .chartForegroundStyleScale([                
                "Voters": Color.primaryDim
            ])
            .chartSelected_X_String($selectedBucket)
        }

        private func annotationPositionForBucket(bucket: String) -> AnnotationPosition {
            let groups = dataSource.groups.split(separator: ",").map(String.init)
            guard let bucketIndex = groups.firstIndex(of: bucket) else {
                // last item from backend returned with `+` suffix
                return .leading
            }
            return bucketIndex < groups.count / 2 ? .trailing : .leading
        }
    }
    
    private struct AnnotationView: View {
        let bucket: String
        let dataSource: UserBucketsDataSource
        
        var voters: Int {
            dataSource.votersInBucket(bucket) ?? 0
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(String(voters))
                            .font(.title3Regular)
                            .foregroundColor(.textWhite)
                        Text(voters == 1 ? "Voter" : "Voters")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
                HStack {
                    HStack(spacing: 4) {
                        Text(bucket)
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                        Text(bucket == "1" ? "time" :" times")
                            .font(.subheadlineRegular)
                            .foregroundColor(.textWhite60)
                    }
                    Spacer()
                }
            }
            .padding(8)
            .background(Color.containerBright)
            .cornerRadius(10)
        }
    }
}
