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
            AppUpdateHeaderView()
            AppUpdateBackgroundView()
            AppUpdateFooterControlsView()
        }
        .padding()
        .onAppear() {Tracker.track(.appUpdateBlockScreen)}
    }
}

fileprivate struct AppUpdateFooterControlsView: View {
    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Go to App Store") {
                Haptic.medium()
                Tracker.track(.openAppStoreLink)
                // go to app store here
            }
            
            Button("Contact us in Discord") {
                Tracker.track(.openDiscordLink)
                // go to discord here
            }
            .fontWeight(.semibold)
            .tint(.textWhite40)
        }
    }
}

fileprivate struct AppUpdateBackgroundView: View {
    var body: some View {
        Image("new-update-background")
            .resizable()
            .scaledToFit()
            .padding(.bottom)
    }
}

fileprivate struct AppUpdateHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    HStack(spacing: 10) {
                        Text("A")
                            .foregroundStyle(Color.textWhite)
                        Text("new update")
                            .foregroundStyle(Color.primaryDim)
                    }
                    
                    Text("is available")
                        .foregroundStyle(Color.textWhite)
                }
                .font(.chillaxMedium(size: 46))
                .kerning(-2.5)
                
                Spacer()
            }
            
            Text("Please install the latest version to continue using the app, if you need additional support contact us in our Discord")
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.textWhite)
                .font(.chillaxRegular(size: 17))
        }
    }
}
