//
//  DaoCardWideView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoCardWideView: View {
    let dao: Dao
    let onSelectDao: ((Dao) -> Void)?
    let onFollowToggle: ((_ didFollow: Bool) -> Void)?
    @Environment(\.isPresented) private var isPresented

    private var backgroundColor: Color {
        isPresented ? .containerBright : .container
    }

    var body: some View {
        HStack(spacing: 8) {
            RoundPictureView(image: dao.avatar(size: .l), imageSize: Avatar.Size.l.daoImageSize)
                .onTapGesture {
                    onSelectDao?(dao)
                }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(dao.name)
                        .font(.headlineSemibold)
                        .foregroundStyle(Color.textWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)

                    if dao.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.textWhite)
                    }
                }

                HStack(spacing: 0) {
                    let proposals = Utils.formattedNumber(Double(dao.proposals))
                    Text("\(proposals)")
                        .font(.captionSemibold)
                        .foregroundStyle(Color.textWhite)
                    Text(" proposals")
                        .font(.сaptionRegular)
                        .foregroundStyle(Color.textWhite60)
                }

                HStack(spacing: 0) {
                    let voters = Utils.formattedNumber(Double(dao.voters))
                    Text("\(voters)")
                        .font(.captionSemibold)
                        .foregroundStyle(Color.textWhite)
                    Text(" voters")
                        .font(.сaptionRegular)
                        .foregroundStyle(Color.textWhite60)
                }
            }

            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id, onFollowToggle: onFollowToggle)
                // we change ID here becase SwiftUI not alway correctly update this component
                // when following/unfollowing from other views
                .id("\(dao.id)-\(dao.subscriptionMeta == nil)")
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
    }
}

#Preview {
    DaoCardWideView(dao: .aave, onSelectDao: nil, onFollowToggle: nil)
}
