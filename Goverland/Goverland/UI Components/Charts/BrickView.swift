//
//  BrickView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct BrickView: View {
    let header: String
    let description: String
    let data: String
    let metadata: String
    let metadataColor: Color

    let width: CGFloat?
    let height: CGFloat?
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let onRefresh: () -> Void

    init(header: String,
         description: String,
         data: String,
         metadata: String,
         metadataColor: Color = Color.textWhite60,
         width: CGFloat? = nil,
         height: CGFloat? = 80,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         onRefresh: @escaping () -> Void) {
        self.header = header
        self.description = description
        self.data = data
        self.metadata = metadata
        self.metadataColor = metadataColor
        self.width = width
        self.height = height
        self.isLoading = isLoading
        self.failedToLoadInitialData = failedToLoadInitialData
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        VStack {
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .foregroundStyle(Color.textWhite20)
                        .controlSize(.regular)
                    Spacer()
                }
            } else if failedToLoadInitialData {
                HStack {
                    Spacer()
                    RefreshIcon {
                        onRefresh()
                    }
                    Spacer()
                }
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text(header)
                            .font(.footnoteRegular)
                            .minimumScaleFactor(0.7)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.textWhite40)
                    }
                    .foregroundStyle(Color.textWhite60)
                    
                    Text(data)
                        .font(.largeTitleRegular)
                        .foregroundStyle(Color.textWhite)
                    Text(metadata)
                        .font(.subheadlineRegular)
                        .foregroundStyle(metadataColor)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showInfoAlert(description)
                }
            }
        }
        .frame(width: width, height: height)
        .padding(Constants.horizontalPadding)
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

struct ShimmerBrickView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ShimmerView()
                    .frame(width: 90, height: 16)
                    .cornerRadius(8)
                Spacer()
            }
            ShimmerView()
                .frame(width: 100, height: 36)
                .cornerRadius(10)
            ShimmerView()
                .frame(width: 50, height: 16)
                .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 112)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container))
    }
}
