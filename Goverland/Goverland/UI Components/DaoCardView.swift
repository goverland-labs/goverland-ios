//
//  DaoCardView.swift
//  Goverland
//
//  Created by Jenny Shalai on 15.06.23.
//

import SwiftUI

struct DaoCardView: View {
    let dao: Dao

    var body: some View {
        VStack {
            RoundPictureView(image: dao.avatar, imageSize: 90)
                .padding(.top, 17)
            
            VStack(spacing: 3) {
                Text(dao.name)
                    .font(.headlineSemibold)
                    .foregroundColor(.textWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("18.2K members")
                    .font(.сaption2Regular)
                    .foregroundColor(.textWhite60)
            }
            .padding(.horizontal, 12)

            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id)
                .padding(.bottom, 20)
        }
        .frame(width: 140, height: 215)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}

struct ShimmerDaoCardView: View {
    var body: some View {
        VStack {
            ShimmerView()
                .frame(width: 90, height: 90)
                .cornerRadius(45)
                .padding(.top, 17)

            VStack(spacing: 3) {
                ShimmerView()
                    .frame(width: 60, height: 20)
                    .cornerRadius(10)
                ShimmerView()
                    .frame(width: 80, height: 16)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 12)

            Spacer()
            ShimmerFollowButtonView()
                .padding(.bottom, 20)
        }
        .frame(width: 140, height: 215)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}

struct DaoCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DaoCardView(dao: .aave)
            ShimmerDaoCardView()
        }
    }
}
