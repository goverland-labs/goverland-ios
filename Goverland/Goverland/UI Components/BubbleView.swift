//
//  BubbleView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 23.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct BubbleView: View {
    let image: Image?
    let text: Text?
    let textColor: Color
    let backgroundColor: Color

    var body: some View {
        HStack(spacing: 3) {
            image
                .font(.system(size: 10))
                .foregroundColor(textColor)
                .frame(height: 14)
            if let text {
                text
                    .font(.сaption2Regular)
                    .foregroundColor(textColor)
                    .lineLimit(1)
            }
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        .background(Capsule().fill(backgroundColor))
    }
}
