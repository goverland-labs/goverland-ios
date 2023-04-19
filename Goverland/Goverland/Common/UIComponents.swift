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

struct FollowButtonView: View {
    @State private var didTap: Bool = false
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    
    var body: some View {
        Button(action: { didTap.toggle() }) {
            Text(didTap ? "Following" : "Follow")
        }
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .foregroundColor(didTap ? .onSecondaryContainer : .onPrimary)
        .fontWeight(.semibold)
        .font(.footnote)
        .background(didTap ? Color.secondaryContainer : Color.primary)
        .cornerRadius(buttonHeight / 2)
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        DaoPictureView(daoImage: URL(string: ""), imageSize: 50)
        FollowButtonView(buttonWidth: 150, buttonHeight: 35)
    }
}
