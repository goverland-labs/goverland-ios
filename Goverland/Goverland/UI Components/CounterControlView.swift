//
//  CounterControlView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-08-09.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct CounterControlView: View {
    let systemImageName: String
    let width: CGFloat
    let height: CGFloat
    let backgroundColor: Color
    let longPressTimeInterval: TimeInterval
    let action: () -> Void
    
    @State private var timer: Timer?
    
    init(systemImageName: String,
         width: CGFloat = 40,
         height: CGFloat = 40,
         backgroundColor: Color,
         longPressTimeInterval: TimeInterval = 0.1,
         action: @escaping () -> Void) {
        self.systemImageName = systemImageName
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
        self.longPressTimeInterval = longPressTimeInterval
        self.action = action
    }
    
    var body: some View {
        Image(systemName: systemImageName)
            .frame(width: width, height: height)
            .background(backgroundColor)
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .onEnded { value in
                        timer = Timer.scheduledTimer(withTimeInterval: longPressTimeInterval, repeats: true) { _ in
                            action()
                        }
                    }
                    .sequenced(before: DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            timer?.invalidate()
                        }
                    )
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        action()
                    }
            )
    }
}
