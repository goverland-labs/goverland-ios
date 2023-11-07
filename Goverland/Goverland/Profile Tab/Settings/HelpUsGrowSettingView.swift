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
                        .foregroundColor(.primaryDim)
                        .frame(width: 30)
                    Text("Rate the App")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.textWhite40)
                }
            }

            Button(action: {
                let tweetText = "Check out Goverland App by @goverland_xyz!"
                let tweetUrl = tweetText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let twitterUrl = URL(string: "https://twitter.com/intent/tweet?text=\(tweetUrl ?? "")")

                if let url = twitterUrl {
                    openUrl(url)
                }

                Tracker.track(.settingsShareTweet)
            }) {
                HStack {
                    HStack {
                        Image("share-tweet")
                            .foregroundColor(.primaryDim)
                            .frame(width: 30)
                        Text("Share a tweet")
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.textWhite40)
                    }
                }
            }
        }
        .accentColor(.textWhite)
        .onAppear() { Tracker.track(.screenHelpUsGrow) }
    }
}
