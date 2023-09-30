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
    
    @State private var isTooltipVisible = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    Text(header)
                        .font(.title3Semibold)
                        .foregroundColor(.textWhite)
                    Spacer()
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
                            }
                        }
                }
                .padding([.top, .horizontal])
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .foregroundColor(.textWhite20)
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
                        .onTapGesture() {
                            if isTooltipVisible {
                                withAnimation {
                                    isTooltipVisible.toggle()
                                }
                            }
                        }
                }
            }
            .frame(width: width, height: height)
            .background(Color.clear)
        }
    }
}
