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
            UserPictureView(user: user, imageSize: 16)
            UserNameView(user: user)
        }
    }
}

fileprivate struct UserPictureView: View {
    let user: User
    let imageSize: Int
    var body: some View {
        KFImage(user.image)
            .placeholder {
                user.image == nil ?
                (user.address.blockie ?? Image(systemName: "circle.fill")) :
                Image(systemName: "circle.fill")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
            .clipShape(Circle())
            .foregroundColor(.containerBright)
    }
}

fileprivate struct UserNameView: View {
    var user: User

    var body: some View {
        ZStack {
            if let name = user.ensName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(user.address.short)
            }
        }
        .font(.system(size: 13))
        .minimumScaleFactor(0.9)
        .lineLimit(1)
        .fontWeight(.medium)
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
