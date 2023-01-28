//
//  IntroViewLoadingView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-28.
//

import SwiftUI

struct IntroViewLoadingView: View {
    
    @State var isAnimationFinished = false
    
    var body: some View {
        if isAnimationFinished {
            IntroView()
        } else {
            VStack(spacing: 30) {
                Image(systemName: "timer.circle")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(.white.opacity(0.6))
                HStack {
                    Text("DAO")
                        .bold()
                    Text("TRACKER")
                }
                .font(.title)
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("LoadingViewColor"))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                withAnimation(.easeIn(duration: 0.2).delay(1)) {
                    isAnimationFinished = true
                }
            }
        }
    }
}

struct IntroViewLogoPreview_Previews: PreviewProvider {
    static var previews: some View {
        IntroViewLoadingView()
    }
}
