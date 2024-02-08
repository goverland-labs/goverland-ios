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
    @StateObject private var orientationManager = DeviceOrientationManager.shared
    
    var body: some View {
        ZStack {
            LottieIntroView().id(orientationManager.currentOrientation)
            
            VStack {
                Spacer()
                PrimaryButton("Get Started") {
                    Haptic.medium()
                    termsViewIsPresented = true
                }
                .padding(.bottom, getPadding())
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $termsViewIsPresented) {
            TermsView(termsViewIsPresented: $termsViewIsPresented)
                .presentationDetents([.height(540), .large])
        }        
    }
}

fileprivate func getPadding() -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.isSmall {
        return 20
    } else {
        return 40
    }
}
