//
//  BrickView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//

import SwiftUI

struct BrickView: View {
    let header: String
    let data: String
    let metadata: String

    let width: CGFloat?
    let height: CGFloat?
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let onRefresh: () -> Void
    
    init(header: String,
         data: String,
         metadata: String,
         width: CGFloat? = nil,
         height: CGFloat? = 80,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         onRefresh: @escaping () -> Void) {
        self.header = header
        self.data = data
        self.metadata = metadata
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
                        .foregroundStyle(Color.textWhite60)
                }
            }
        }
        .frame(width: width, height: height)
        .padding()
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}
