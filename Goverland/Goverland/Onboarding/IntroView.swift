//
//  IntroView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct IntroView: View {
    @State var termsViewIsPresented = false
    @StateObject private var orientationManager = DeviceOrientationManager()
    
    var body: some View {
        ZStack {
            LottieIntroView().id(orientationManager.currentOrientation)
            
            VStack {
                Spacer()
                PrimaryButton("Get Started") {
                    termsViewIsPresented = true
                }
                .padding(.bottom, getPadding())
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $termsViewIsPresented) {
            TermsView(termsViewIsPresented: $termsViewIsPresented)
                .presentationDetents([.medium, .large])
        }        
    }
}

fileprivate func getPadding() -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.screenHeight <= 667.0 {
        // iPhone SE or smaller
        return 20
    } else {
        return 40
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
