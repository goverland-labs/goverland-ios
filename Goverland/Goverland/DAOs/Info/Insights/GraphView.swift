//
//  GraphView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 12.09.23.
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
    
    @State private var isTooltipVisible = false

    var body: some View {
        VStack {
            HStack {
                Text(header)
                    .font(.title3Semibold)
                    .foregroundColor(.textWhite)
                Spacer()
                if let subheader {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.textWhite40)
                        .padding(.trailing)
                        .tooltip($isTooltipVisible) {
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
