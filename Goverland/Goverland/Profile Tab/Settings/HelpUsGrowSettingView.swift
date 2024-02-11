//
//  HelpUsGrowSettingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 08.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import StoreKit

struct HelpUsGrowSettingView: View {
    var body: some View {
        List{
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                Tracker.track(.settingsRateTheApp)
            }) {
                HStack {
                    Image("rate-app")
                        .foregroundStyle(Color.primaryDim)
                        .frame(width: 30)
                    Text("Rate the App")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(Color.textWhite40)
                }
            }

            Button(action: {
                let postText = "Check out Goverland App by @goverland_xyz!"
                let postUrl = postText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let XUrl = URL(string: "https://x.com/intent/tweet?text=\(postUrl ?? "")")

                if let url = XUrl {
                    openUrl(url)
                }

                Tracker.track(.settingsShareXPost)
            }) {
                HStack {
                    HStack {
                        Image("share-x-post")
                            .foregroundStyle(Color.primaryDim)
                            .frame(width: 30)
                        Text("Share a post on X")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(Color.textWhite40)
                    }
                }
            }
        }
        .tint(.textWhite)
        .onAppear() { Tracker.track(.screenHelpUsGrow) }
    }
}
