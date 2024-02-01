//
//  GraphView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.09.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

protocol GraphViewContent: View {}

struct GraphView<Content: GraphViewContent>: View {
    let header: String
    let subheader: String?
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let width: CGFloat?
    let height: CGFloat?
    let onRefresh: () -> Void
    
    let content: Content
    
    init(header: String,
         subheader: String?,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         width: CGFloat? = nil,
         height: CGFloat? = 300,
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
            GraphHeaderView(header: header, subheader: subheader)
            if isLoading {
                Spacer()
                ProgressView()
                    .foregroundColor(.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if failedToLoadInitialData {
                Spacer()
                RefreshIcon {
                    onRefresh()
                }                
                Spacer()
            } else {
                content
                    .zIndex(-1)
            }
        }
        .frame(width: width, height: height)
        .background(Color.clear)        
    }
}
