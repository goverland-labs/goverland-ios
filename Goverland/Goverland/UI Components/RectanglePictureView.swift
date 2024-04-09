//
//  RectanglePictureView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.12.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import Kingfisher

struct RectanglePictureView: View {
    let image: URL?
    let imageSize: CGSize
    let cornerRadius: CGFloat

    @State private var failedToLoad = false

    init(image: URL?, 
         imageSize: CGSize,
         cornerRadius: CGFloat? = nil
    ) {
        self.image = image
        self.imageSize = imageSize
        if let cornerRadius {
            self.cornerRadius = cornerRadius
        } else {
            self.cornerRadius = imageSize.width / 8
        }
    }

    var body: some View {
        if !failedToLoad {
            KFImage(image)
                .placeholder {
                    ShimmerView()
                        .frame(width: imageSize.width, height: imageSize.height)
                        .cornerRadius(cornerRadius)
                }
                .onFailure { _ in
                    failedToLoad = true
                }
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .cornerRadius(cornerRadius)

        } else {
            Rectangle()
                .foregroundStyle(Color.containerBright)
                .cornerRadius(cornerRadius)
                .frame(width: imageSize.width, height: imageSize.height)
        }
    }
}
