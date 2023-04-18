//
//  UIComponents.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-14.
//

import SwiftUI
import Kingfisher

struct DaoPictureView: View {
    let daoImage: URL?
    let imageSize: Int
    var body: some View {
        KFImage(daoImage)
            .placeholder {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize)), mode: .aspectFill))
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
            .cornerRadius(CGFloat(imageSize / 2))
    }
}

struct UserPictureView: View {
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

struct FollowButtonView: View {
    @State private var didTap: Bool = false
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .foregroundColor(didTap ? .blue : .white)
        .fontWeight(.medium)
        .background(didTap ? Color("followButtonColorActive") : Color.blue)
        .cornerRadius(5)
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        DaoPictureView(daoImage: URL(string: ""), imageSize: 50)
        UserPictureView(userImage: URL(string: ""), imageSize: 15)
        FollowButtonView(buttonWidth: 150, buttonHeight: 35)
    }
}



