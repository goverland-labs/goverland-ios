//
//  RoundPictureView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-14.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import Kingfisher

struct RoundPictureView: View {
    let image: URL?
    let imageSize: CGFloat

    @State private var failedToLoad = false

    var body: some View {
        if !failedToLoad {
            KFImage(image)
                .placeholder {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        ProgressView()
                            .foregroundColor(.textWhite20)
                            .controlSize(.mini)
                    } else {
                        ShimmerView()
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(imageSize / 2)
                    }
                }
                .onFailure { _ in
                    failedToLoad = true
                }
                .resizable()
                .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize),
                                                     mode: .aspectFill))
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(imageSize / 2)

        } else {
            Circle()
                .foregroundColor(.containerBright)
                .frame(width: imageSize, height: imageSize)
        }
    }
}

struct UIComponents_Previews: PreviewProvider {
    static var previews: some View {
        RoundPictureView(image: URL(string: ""), imageSize: 50)
    }
}
