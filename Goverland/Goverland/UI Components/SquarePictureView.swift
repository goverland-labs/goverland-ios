//
//  SquarePictureView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Kingfisher

struct SquarePictureView: View {
    let image: URL?
    let imageSize: CGFloat

    @State private var failedToLoad = false

    var body: some View {
        if !failedToLoad {
            KFImage(image)
                .placeholder {
                    ShimmerView()
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(imageSize / 8)
                }
                .onFailure { _ in
                    failedToLoad = true
                }
                .resizable()
                .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: imageSize, height: imageSize),
                                                     mode: .aspectFill))
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(imageSize / 8)

        } else {
            Rectangle()
                .foregroundColor(.containerBright)
                .cornerRadius(imageSize / 8)
                .frame(width: imageSize, height: imageSize)
        }
    }
}
