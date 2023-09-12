//
//  ShimmerView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-30.
//

import SwiftUI

struct ShimmerView: View {
    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint
    private var animate: Bool
    private var gradientColors: [Color]       

    init(startPoint: UnitPoint = .init(x: -1.8, y: -1.2),
         endPoint: UnitPoint = .init(x: 0, y: -0.2),
         animate: Bool = true,
         gradientColors: [Color] = [
            Color(uiColor: UIColor(.container)),
            Color(uiColor: UIColor(.secondaryContainer)),
            Color(uiColor: UIColor(.container))]
    ) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.animate = animate
        self.gradientColors = gradientColors
    }
    
    var body: some View {
        LinearGradient(colors: gradientColors,
                       startPoint: startPoint,
                       endPoint: endPoint)
        .onAppear {
            if animate {
                withAnimation (.easeInOut (duration: 1)
                    .repeatCount(5, autoreverses: false)) {
                        startPoint = .init(x: 1, y: 1)
                        endPoint = .init(x: 2.2, y: 2.2)
                    }
            }
        }
    }
}
