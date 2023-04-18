//
//  IdentityView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//

import SwiftUI
import Kingfisher

struct IdentityView: View {
    var user: User

    var body: some View {
        HStack(spacing: 6) {
            UserPictureView(userImage: user.image, imageSize: 16)
            UserNameView(user: user)
        }
    }
}

fileprivate struct UserPictureView: View {
    let userImage: URL?
    let imageSize: Int
    var body: some View {
        KFImage(userImage)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.purple)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize), mode: .aspectFit))
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
    }
}

// TODO: implement truncate logic to keep 4 first and 4 last chars
// frame restrictions won't work for bigger screens
fileprivate struct UserNameView: View {
    var user: User

    var body: some View {
        ZStack {
            if let name = user.ensName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(user.address)
                    .truncationMode(.middle)
            }
        }
        .font(.system(size: 13))
        .minimumScaleFactor(0.9)
        .lineLimit(1)
        .fontWeight(.medium)
        .foregroundColor(.textWhite)
        .frame(width: 70)
    }
}
