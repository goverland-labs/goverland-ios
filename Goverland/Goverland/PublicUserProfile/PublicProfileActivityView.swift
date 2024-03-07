//
//  PublicProfileActivityView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-03-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct PublicProfileActivityView: View {
    let dataSource: PublicProfileDataSource
    
    var body: some View {
        VotesInDaosView(data: dataSource)
        VotesListView()
    }
}

fileprivate struct VotesInDaosView: View {
    let data: PublicProfileDataSource
    var body: some View {
        if data.failedToLoadInitialData {
            RefreshIcon {
                data.refresh()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    if data.profile?.daos == nil { // initial loading
                        ForEach(0..<3) { _ in
                            ShimmerView()
                                .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                                .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        }
                    } else {
                        ForEach(data.profile!.daos) { dao in
                            RoundPictureView(image: dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                        }
                    }
                }
                .background(Color.container)
                .cornerRadius(20)
                .padding(.horizontal, 8)
            }
        }
    }
}

fileprivate struct VotesListView: View {
    var body: some View {
        EmptyView()
        //list of proposals where this public user voted
    }
}
