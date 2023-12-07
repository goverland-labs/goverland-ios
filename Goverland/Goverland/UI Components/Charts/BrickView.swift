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
    let data: String
    let metadata: String
    let metadataColor: Color

    let width: CGFloat?
    let height: CGFloat?
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let onRefresh: () -> Void
    
    init(header: String,
         data: String,
         metadata: String,
         metadataColor: Color = Color.textWhite60,
         width: CGFloat? = nil,
         height: CGFloat? = 80,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         onRefresh: @escaping () -> Void) {
        self.header = header
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
                        .foregroundColor(.textWhite20)
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
                        Spacer()
                    }
                    .foregroundStyle(Color.textWhite60)
                    
                    Text(data)
                        .font(.largeTitleRegular)
                        .foregroundStyle(Color.textWhite)
                    Text(metadata)
                        .font(.subheadlineRegular)
                        .foregroundStyle(metadataColor)
                }
            }
        }
        .frame(width: width, height: height)
        .padding()
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}