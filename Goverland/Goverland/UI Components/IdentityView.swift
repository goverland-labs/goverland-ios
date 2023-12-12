//
//  IdentityView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Kingfisher

struct IdentityView: View {
    var user: User
    let size: Size

    enum Size {
        case small, medium

        var imageSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 32
            }
        }

        var textFont: Font {
            switch self {
            case .small: return .footnoteRegular
            case .medium: return .bodySemibold
            }
        }
    }

    init(user: User, size: Size = .small) {
        self.user = user
        self.size = size
    }

    var body: some View {
        HStack(spacing: 6) {
            UserPictureView(user: user, imageSize: size.imageSize)
            UserNameView(user: user, font: size.textFont)
        }
    }
}

struct UserPictureView: View {
    let user: User
    let imageSize: CGFloat
    var body: some View {
        KFImage(user.avatar)
            .placeholder {
                user.avatar == nil ?
                (user.address.blockie ?? Image(systemName: "circle.fill")) :
                Image(systemName: "circle.fill")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize, height: imageSize)
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
