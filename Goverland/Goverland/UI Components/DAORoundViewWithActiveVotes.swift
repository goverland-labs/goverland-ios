//
//  DAORoundViewWithActiveVotes.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 25.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DAORoundViewWithActiveVotes: View {
    let dao: Dao
    let onDaoOpen: (() -> Void)

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundPictureView(image: dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                .onTapGesture {
                    onDaoOpen()
                }

            if let activeVotes = dao.activeVotes, activeVotes > 0 {
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
