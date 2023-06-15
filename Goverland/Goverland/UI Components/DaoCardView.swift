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
            RoundPictureView(image: dao.image, imageSize: 90)
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
            Spacer()
            FollowButtonView(daoID: dao.id, subscriptionID: dao.subscriptionMeta?.id)
        }
        .frame(width: 130, height: 200)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
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

            VStack(spacing: 3) {
                ShimmerView()
                    .frame(width: 70, height: 20)
                    .cornerRadius(10)
                ShimmerView()
                    .frame(width: 50, height: 16)
                    .cornerRadius(8)
            }
            Spacer()
            ShimmerView()
                .frame(width: 110, height: 35)
                .cornerRadius(17)

        }
        .frame(width: 130, height: 200)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))

    }
}

struct DaoCardView_Previews: PreviewProvider {
    static var previews: some View {
        DaoCardView(dao: .aave)
        ShimmerDaoCardView()
    }
}
