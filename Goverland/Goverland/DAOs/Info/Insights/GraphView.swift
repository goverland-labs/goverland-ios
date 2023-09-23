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
    
    @State var isDescriptionPresent = false
    
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
                        .onTapGesture() {
                            withAnimation {
                                isDescriptionPresent.toggle()
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
                }
            }
            .frame(width: width, height: height)
            .background(Color.clear)
            
            HStack {
                Spacer()
                if isDescriptionPresent {
                    QuestionMarkDescriptionView(info: subheader)
                }
            }
            .offset(x: -50, y: 45)
        }
        .onTapGesture() {
            if isDescriptionPresent {
                withAnimation {
                    isDescriptionPresent.toggle()
                }
            }
        }
    }
}

fileprivate struct QuestionMarkDescriptionView: View {
    let info: String
    var body: some View {
        Text(info)
            .padding()
            .background(Color.containerBright)
            .cornerRadius(10)
            .font(.footnoteRegular)
            .frame(maxWidth: 250, alignment: .topTrailing)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "arrowtriangle.up.fill")
                    .rotationEffect(.degrees(45))
                    .offset(x: 7, y: -7)
                    .foregroundColor(Color.containerBright)
            }
    }
}
