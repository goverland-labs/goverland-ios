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
        VStack {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else {
                VStack {
                    VStack(spacing: 3) {
                        HStack {
                            Text("User Buckets")
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
                            ForEach(dataSource.userBuckets.indices, id: \.self) { i in
                                BarMark (
                                    x: .value("Bucket", dataSource.userBuckets[i].votes),
                                    y: .value("Voters", dataSource.userBuckets[i].voters)
                                )
                                .annotation {
                                    if dataSource.userBuckets[i].voters == 0 {
                                        Text("0")
                                            .foregroundColor(.textWhite40)
                                            .font(.сaption2Regular)
                                    }
                                }
                                .foregroundStyle(Color.chartBar)
                            }
                        }
                        .frame(height: 200)
                        .padding()
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
            if dataSource.userBuckets.isEmpty {
                dataSource.refresh()
            }
        }
    }
}

struct UserBucketsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        UserBucketsGraphView(dao: .aave)
    }
}
