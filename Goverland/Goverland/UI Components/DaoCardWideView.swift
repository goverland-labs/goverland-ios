//
//  DaoCardWideView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DaoCardWideView: View {
    @Binding var dao: Dao
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

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
        }
        .padding(.vertical, 16)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
        .onReceive(NotificationCenter.default.publisher(for: .subscriptionDidToggle)) { notification in
            if let (daoId, subscriptionMeta) = notification.object as? (UUID, SubscriptionMeta?) {
                if dao.id == daoId {
                    dao = dao.withSubscriptionMeta(subscriptionMeta)
                }
            }
        }
    }
}

#Preview {
    DaoCardWideView(dao: .constant(.aave), onSelectDao: nil, onFollowToggle: nil)
}
