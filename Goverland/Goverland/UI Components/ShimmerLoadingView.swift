//
//  ShimmerView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-30.
//

import SwiftUI

struct ShimmerView: View {
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    private var gradientColors = [
        Color(uiColor: UIColor(.container)),
        Color(uiColor: UIColor(.secondaryContainer)),
        Color(uiColor: UIColor(.container))]
    
    var body: some View {
        LinearGradient (colors: gradientColors,
                        startPoint: startPoint,
                        endPoint: endPoint)
        .onAppear {
            withAnimation (.easeInOut (duration: 1)
                .repeatForever (autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                }
        }
    }
}

struct ShimmerLoadingItemView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)
            
            VStack(spacing: 15) {
                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 100)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 80)
                }
                .frame(height: 20)
                
                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 250)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(25)
                        .frame(width: 50, height: 50)
                }
                .frame(height: 50)
                
                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 250)
                    Spacer()
                }
                .frame(height: 20)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
        }
    }
}

struct ShimmerLoadingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerLoadingItemView()
    }
}
