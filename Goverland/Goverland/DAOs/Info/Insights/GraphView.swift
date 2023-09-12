//
//  GraphView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.09.23.
//

import SwiftUI

struct GraphView<Content: View>: View {
    let header: String
    let subheader: String
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let width: CGFloat?
    let height: CGFloat?
    let onRefresh: () -> Void

    let content: Content

    init(header: String,
         subheader: String,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         width: CGFloat? = nil,
         height: CGFloat?,
         onRefresh: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.header = header
        self.subheader = subheader
        self.isLoading = isLoading
        self.failedToLoadInitialData = failedToLoadInitialData
        self.width = width
        self.height = height
        self.onRefresh = onRefresh
        self.content = content()
    }

    var body: some View {
        VStack {
            VStack(spacing: 3) {
                HStack {
                    Text(header)
                        .font(.title3Semibold)
                        .foregroundColor(.textWhite)
                        .padding([.horizontal, .top])
                    Spacer()
                }

                HStack {
                    Text(subheader)
                        .font(.footnote)
                        .foregroundColor(.textWhite40)
                        .padding([.horizontal])
                    Spacer()
                }
            }

            if isLoading {
                Spacer()
                ProgressView()
                    .foregroundColor(Color.textWhite20)
                    .controlSize(.large)
                Spacer()
            } else if failedToLoadInitialData {
                Spacer()
                Button("Refresh") {
                    onRefresh()
                }
                .foregroundColor(.primary)
                Spacer()
            } else {
                content
            }
        }
        .frame(width: width, height: height)
        .background(Color.containerBright)
        .cornerRadius(20)
        .padding()
    }
}
