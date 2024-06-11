//
//  DelegateCardView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 11.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct DelegateCardView: View {
    let delegate: Delegate
    @Environment(\.isPresented) private var isPresented

    private var backgroundColor: Color {
        isPresented ? .containerBright : .container
    }

    var body: some View {
        VStack {
            RoundPictureView(image: delegate.user.avatar(size: .l), imageSize: Avatar.Size.l.profileImageSize)
                .padding(.top, 18)                

            HStack {
                Spacer()
                Text(delegate.user.username)
                    .font(.headlineSemibold)
                    .foregroundStyle(Color.textWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, Constants.horizontalPadding)
                Spacer()
            }

            Spacer()
        }
        .frame(height: 230)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor))
    }
}

struct ShimmerDelegateCardView: View {
    var body: some View {
        VStack {
            ShimmerView()
                .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                .cornerRadius(Avatar.Size.l.profileImageSize / 2)
                .padding(.top, 18)

            HStack {
                Spacer()
                ShimmerView()
                    .frame(width: 60, height: 20)
                    .cornerRadius(10)
                    .padding(.horizontal, Constants.horizontalPadding)
                Spacer()
            }
            Spacer()
        }
        .frame(height: 230)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}
