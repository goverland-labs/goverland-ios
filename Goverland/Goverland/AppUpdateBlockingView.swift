//
//  AppUpdateBlockingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-12.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI

struct AppUpdateBlockingView: View {
    var body: some View {
        VStack {
            Text("A new version of the app is available.")
                .font(.title3Regular)
                .foregroundColor(.dangerText)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Update") {
                // add app store link here
            }
            .padding()
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(10)
    }
}
