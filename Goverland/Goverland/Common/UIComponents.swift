//
//  UIComponents.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-14.
//

import SwiftUI
import Kingfisher

struct RoundPictureView: View {
    let image: URL?
    let imageSize: Int
    var body: some View {
        KFImage(image)
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
        .font(.footnoteSemibold)
        .background(didTap ? Color.secondaryContainer : Color.primary)
        .cornerRadius(buttonHeight / 2)
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        RoundPictureView(image: URL(string: ""), imageSize: 50)
        FollowButtonView(buttonWidth: 150, buttonHeight: 35)
    }
}
