//
//  BrickView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-10-20.
//

import SwiftUI

struct BrickView: View {
    let header: String
    let subheader: String
    let data: String
    let metaData: String
    
    let width: CGFloat?
    let height: CGFloat?
    let isLoading: Bool
    let failedToLoadInitialData: Bool
    let onRefresh: () -> Void
    
    init(header: String,
         subheader: String,
         data: String,
         metaData: String,
         width: CGFloat? = nil,
         height: CGFloat?,
         isLoading: Bool,
         failedToLoadInitialData: Bool,
         onRefresh: @escaping () -> Void) {
        self.header = header
        self.subheader = subheader
        self.data = data
        self.metaData = metaData
        self.width = width
        self.height = height
        self.isLoading = isLoading
        self.failedToLoadInitialData = failedToLoadInitialData
        self.onRefresh = onRefresh
    }
    
    @State private var isTooltipVisible = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.textWhite40)
                        .tooltip($isTooltipVisible, width: 100) {
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
                Spacer()
            }
            
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .foregroundColor(.textWhite20)
                        .controlSize(.large)
                        .frame(height: height)
                    Spacer()
                }
                .zIndex(-1)
            } else if failedToLoadInitialData {
                HStack {
                    Spacer()
                    RefreshIcon {
                        onRefresh()
                    }
                    .frame(height: height)
                    Spacer()
                }
                .zIndex(-1)
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
                    Text(metaData)
                        .font(.subheadlineRegular)
                        .foregroundStyle(Color.textWhite60)
                }
                .zIndex(-1)
            }
        }
        .frame(height: height)
        .padding()
        .background(Color.containerBright)
        .cornerRadius(20)
    }
}

#Preview {
    BrickView(header: "",
              subheader: "",
              data: "",
              metaData: "",
              width: 10,
              height: 10,
              isLoading: false,
              failedToLoadInitialData: false,
              onRefresh: {() -> Void in })
}
