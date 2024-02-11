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
                    ShimmerView()
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(imageSize / 2)
                }
                .onFailure { _ in
                    failedToLoad = true
                }
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(imageSize / 2)

        } else {
            Circle()
                .foregroundStyle(Color.containerBright)
                .frame(width: imageSize, height: imageSize)
        }
    }
}
