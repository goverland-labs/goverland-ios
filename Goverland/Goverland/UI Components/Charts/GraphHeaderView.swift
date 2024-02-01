//
//  GraphHeaderView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.01.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct GraphHeaderView: View {
    let header: String
    let subheader: String?
    let tooltipSide: TooltipSide

    init(header: String, subheader: String?, tooltipSide: TooltipSide = .bottomLeft) {
        self.header = header
        self.subheader = subheader
        self.tooltipSide = tooltipSide
        self.isTooltipVisible = isTooltipVisible
    }

    @State private var isTooltipVisible = false

    var body: some View {
        HStack {
            Text(header)
                .font(.title3Semibold)
                .foregroundColor(.textWhite)
            Spacer()
            if let subheader {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.textWhite40)
                    .padding(.trailing)
                    .tooltip($isTooltipVisible, side: tooltipSide) {
                        Text(subheader)
                            .foregroundColor(.textWhite60)
                            .font(.сaptionRegular)
                    }
                    .onTapGesture() {
                        withAnimation {
                            isTooltipVisible.toggle()
                            // Shoe tooltip for 5 sec only
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                if isTooltipVisible {
                                    isTooltipVisible.toggle()
                                }
                            }
                        }
                    }
            }
        }
        .padding([.top, .horizontal])
    }
}
