//
//  DashboardFollowedDAOsActiveVote.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 24.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DashboardFollowedDAOsActiveVote: View {
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @ObservedObject var dataSource = FollowedDAOsActiveVoteDataSource.shared

    var body: some View {
        if dataSource.failedToLoadInitialData {
            RefreshIcon {
                dataSource.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if dataSource.daos.isEmpty { // initial loading
                        ForEach(0..<3) { _ in
                            ShimmerView()
                                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        }
                    } else {
                        ForEach(dataSource.daos) { dao in
                            ZStack(alignment: .bottomTrailing) {
                                RoundPictureView(image: dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                                    .onTapGesture {
                                        activeSheetManger.activeSheet = .daoInfo(dao)
                                        Tracker.track(.dashRecentDaoOpen)
                                    }

                                if let activeVotes = dao.activeVotes {
                                    Text("\(activeVotes)")
                                        .font(.сaption2Regular)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(
                                            Group {
                                                if activeVotes < 10 {
                                                    Circle().foregroundStyle(Color.textWhite)
                                                } else {
                                                    Capsule().foregroundStyle(Color.textWhite)
                                                }
                                            }
                                        )
                                        .foregroundStyle(Color.surface)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.container)
            .cornerRadius(20)
            .padding(.horizontal, 8)
        }
    }
}
