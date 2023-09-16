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
        @State private var selectedBucket: String?
        @State private var selectedBucketVoters: Int?

        var body: some View {
            Chart {
                ForEach(dataSource.userBuckets.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Bucket", dataSource.userBuckets[i].votes),
                        y: .value("Voters", dataSource.userBuckets[i].voters)
                    )
                    .foregroundStyle(Color.chartBar)
                }

                if let selectedBucket, let selectedBucketVoters {
                    RectangleMark(x: .value("Bucket", selectedBucket))
                        .foregroundStyle(.primary.opacity(0.2))
                        .annotation(
                            position: selectedBucket == "13+" ? .leading : .trailing,
                            alignment: .center, spacing: 0
                        ) {
                            AnnotationView(voters: selectedBucketVoters)
                        }
                }
            }
            .padding()
            .chartOverlay { chartProxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    selectedBucket = chartProxy.value(atX: value.location.x, as: String.self)
                                    if let selectedBucket {
                                        selectedBucketVoters = dataSource.votersInBucket(selectedBucket)
                                    }
                                }
                                .onEnded { _ in
                                    selectedBucket = nil
                                    selectedBucketVoters = nil
                                }
                        )
                }
            }
        }
    }
}

fileprivate struct AnnotationView: View {
    let voters: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(String(voters))
                .font(.сaptionRegular)
        }
        .padding()
        .background(Color.containerBright)
        .cornerRadius(8)
    }
}

struct UserBucketsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        UserBucketsGraphView(dao: .aave)
    }
}
