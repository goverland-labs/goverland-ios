//
//  DashboardPopularDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-22.
//

import SwiftUI

struct DashboardPopularDaosView: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @ObservedObject var dataSource = GroupedDaosDataSource.dashboard
    
    let category: DaoCategory = .popular

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                if !dataSource.failedToLoadInitialData {
                    HStack(spacing: 20) {
                        if dataSource.categoryDaos[category] == nil { // initial loading
                            ForEach(0..<3) { _ in
                                ShimmerView()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(45/2)
                            }
                        } else {
                            let count = dataSource.categoryDaos[category]!.count
                            ForEach(0..<count, id: \.self) { index in
                                let dao = dataSource.categoryDaos[category]![index]
                                if index == count - 1 && dataSource.hasMore(category: category) {
                                    if !dataSource.failedToLoad(category: category) { // try to paginate
                                        ShimmerView()
                                            .frame(width: 45, height: 45)
                                            .cornerRadius(45/2)
                                            .onAppear {
                                                dataSource.loadMore(category: category)
                                            }
                                    }
                                } else {
                                    RoundPictureView(image: dao.avatar, imageSize: 45)
                                        .onTapGesture {
                                            activeSheetManger.activeSheet = .daoInfo(dao)
                                            Tracker.track(.dashPopularDaoOpen)
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    RefreshIcon {
                        dataSource.refresh()
                    }
                }
            }
            .background(Color.container)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}

fileprivate struct DaoAvatarView: View {
    
    let dao: Dao
    
    var body: some View {
        VStack {
            RoundPictureView(image: dao.avatar, imageSize: 90)
                .padding(.top, 18)
                .onTapGesture {
                    print("DAO TAPPED: \(dao.name)")
                }
        }
    }
}
