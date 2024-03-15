//
//  ProfileHeaderView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 15.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct ProfileHeaderView: View {
    let user: User?

    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 12) {
                if let user {
                    RoundPictureView(image: user.avatar(size: .l), imageSize: Avatar.Size.l.profileImageSize)
                    ZStack {
                        if let name = user.resolvedName {
                            Text(name)
                                .truncationMode(.tail)
                        } else {
                            Button {
                                UIPasteboard.general.string = user.address.value
                                showToast("Address copied")
                            } label: {
                                Text(user.address.short)
                            }
                        }
                    }
                    .font(.title3Semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.textWhite)
                } else { // Guest profile
                    Image("guest-profile")
                        .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("Guest")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding(.bottom, 6)
        }
        .padding(24)
    }

    struct CounterView: View {
        let counter: Int
        let title: String

        var body: some View {
            VStack(spacing: 4) {
                Text("\(counter)")
                    .font(.bodySemibold)
                    .foregroundStyle(Color.textWhite)
                Text(title)
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite60)
            }
        }
    }
}

struct ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                .cornerRadius(Avatar.Size.l.profileImageSize / 2)

            ShimmerView()
                .cornerRadius(24)
                .frame(width: 100, height: 24)
        }
        .padding(24)
    }
}
