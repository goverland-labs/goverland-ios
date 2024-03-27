//
//  IdentityView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Kingfisher

fileprivate extension Avatar.Size {
    var textFont: Font {
        switch self {
        case .xs: return .footnoteRegular
        case .s: return .bodySemibold
        case .m, .l, .xl: return .bodySemibold // not used atm
        }
    }
}

struct IdentityView: View {
    let user: User
    let size: Avatar.Size
    let onTap: (() -> Void)?

    init(user: User, size: Avatar.Size = .xs, onTap: (() -> Void)?) {
        self.user = user
        self.size = size
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: 6) {
            UserPictureView(user: user, size: size)
            UserNameView(user: user, font: size.textFont)
        }
        .onTapGesture {
            onTap?()
        }
    }
}

struct UserPictureView: View {
    let user: User
    let size: Avatar.Size

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
            .frame(width: size.profileImageSize, height: size.profileImageSize)
            .clipShape(Circle())
            .foregroundStyle(Color.containerBright)
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
        .foregroundStyle(Color.textWhite)        
    }
}

struct Previews_IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            IdentityView(user: User.test, onTap: nil)
            IdentityView(user: User.flipside, onTap: nil)
            IdentityView(user: User.aaveChan, onTap: nil)
        }
        .background(Color.containerDim)
    }
}
