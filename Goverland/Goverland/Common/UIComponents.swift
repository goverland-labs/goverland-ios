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
    let imageSize: CGFloat
    var body: some View {
        KFImage(image)
            .placeholder {
                ShimmerView()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(imageSize / 2)
            }
            .resizable()
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize),
                                                 mode: .aspectFill))
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(imageSize / 2)
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        RoundPictureView(image: URL(string: ""), imageSize: 50)
    }
}
