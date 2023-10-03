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
        GraphView(header: "Voting frequency",
                  subheader: "Categorizing voters into distinct 'buckets' based on the number of user votes.",
                  isLoading: dataSource.isLoading,
                  failedToLoadInitialData: dataSource.failedToLoadInitialData,
                  height: 330,
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

        var body: some View {
            Chart {
                ForEach(dataSource.userBuckets.indices, id: \.self) { i in
                    BarMark (
                        x: .value("Bucket", dataSource.userBuckets[i].votes),
                        y: .value("Voters", dataSource.userBuckets[i].voters)
                    )
                    .foregroundStyle(Color.chartBar)
                }

                if let selectedBucket {
                    RuleMark(x: .value("Bucket", selectedBucket))
                        .foregroundStyle(Color.textWhite)
                        .lineStyle(.init(lineWidth: 1, dash: [2]))
                        .annotation(
                            position: ["8-12", "13+"].contains(selectedBucket) ? .leading : .trailing,
                            alignment: .center, spacing: 4
                        ) {
                            AnnotationView(bucket: selectedBucket, dataSource: dataSource)
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
                                }
                                .onEnded { _ in
                                    selectedBucket = nil
                                }
                        )
                        .onTapGesture(coordinateSpace: .local) { location in
                            selectedBucket = chartProxy.value(atX: location.x, as: String.self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                selectedBucket = nil
                            }
                        }
                }
            }
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
                        Text("Voters")
                            .font(.subheadlineRegular)
                            .foregroundColor(.systemGrayDark)
                    }
                    Spacer()
                }
                HStack {
                    HStack(spacing: 4) {
                        Text(bucket)
                            .font(.subheadlineRegular)
                            .foregroundColor(.systemGrayDark)
                        Text("times")
                            .font(.subheadlineRegular)
                            .foregroundColor(.systemGrayDark)
                    }
                    Spacer()
                }
            }
            .padding(8)
            .background(Color.systemDarkElevatedSecondary)
            .cornerRadius(10)
        }
    }
}

struct UserBucketsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        UserBucketsGraphView(dao: .aave)
    }
}
