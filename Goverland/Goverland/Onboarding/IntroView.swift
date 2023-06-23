//
//  IntroView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct IntroView: View {
    @State var termsViewIsPresented = false
    
    var body: some View {
        ZStack {
            LottieIntroView()
            
            VStack {
                Spacer()
                
                // TODO: move to UI component
                Button("Get Started") {
                    termsViewIsPresented = true
                }
                .ghostActionButtonStyle()
                .padding(.bottom, getPadding())
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .sheet(isPresented: $termsViewIsPresented) {
            TermsView(termsViewIsPresented: $termsViewIsPresented)
                .presentationDetents([.medium, .large])
        }
        .onAppear() { Tracker.track(.introView) }
    }
}

fileprivate func getPadding() -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height <= 667.0 {
        // iPhone SE
        return 10
    } else {
        return 50
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
