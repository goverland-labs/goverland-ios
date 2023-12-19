//
//  IdentityView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Kingfisher

fileprivate extension User.AvatarSize {
    var textFont: Font {
        switch self {
        case .xs, .s: return .footnoteRegular
        case .m, .l, .xl: return .bodySemibold
        }
    }
}

struct IdentityView: View {
    var user: User
    let size: User.AvatarSize

    init(user: User, size: User.AvatarSize = .xs) {
        self.user = user
        self.size = size
    }

    var body: some View {
        HStack(spacing: 6) {
            UserPictureView(user: user, size: size)
            UserNameView(user: user, font: size.textFont)
        }
    }
}

struct UserPictureView: View {
    let user: User
    let size: User.AvatarSize

    var avatarUrl: URL {
        user.avatars.first { $0.size == size }!.link
    }

    var body: some View {
        KFImage(avatarUrl)
            .placeholder {
                user.address.blockie ?? Image(systemName: "circle.fill")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.imageSize, height: size.imageSize)
            .clipShape(Circle())
            .foregroundColor(.containerBright)
    }
}

fileprivate struct UserNameView: View {
    let user: User
    let font: Font

    var body: some View {
        ZStack {
            if let name = user.resolvedName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(user.address.short)
            }
        }
        .font(font)
        .lineLimit(1)
        .foregroundColor(.textWhite)        
    }
}

struct Previews_IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            IdentityView(user: User.test)
            IdentityView(user: User.flipside)
            IdentityView(user: User.aaveChan)
        }
        .background(Color.containerDim)
    }
}
