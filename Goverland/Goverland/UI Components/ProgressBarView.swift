//
//  ProgressBarView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-26.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    let score: Double
    let totalScore: Double
    let height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(Color.secondaryContainer)
                    .frame(height: height)
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(Color.primaryDim)
                    .frame(width: CGFloat(geometry.size.width * score / totalScore), height: height, alignment: .center)
            }
        }
    }
}
