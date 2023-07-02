//
//  EnablePushNotificationsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-16.
//

import SwiftUI

struct EnablePushNotificationsView: View {
    var body: some View {
        ZStack {
            PushNotificationBackgroundView()
            VStack {
                PushNotificationHeaderView()
                Spacer()
                PushNotificationFooterControlsView()
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear() { Tracker.track(.enablePushNotificationsView) }
        }
    }
}

fileprivate struct PushNotificationBackgroundView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 220, height: 220)
                .background(Color.primaryDim)
                .cornerRadius(110)
                .blur(radius: 100)
            
            Image("PushNotificationImage")
        }
    }
}

fileprivate struct PushNotificationFooterControlsView: View {
    @Setting(\.onboardingFinished) var onboardingFinished

    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Enable notifications") {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        // Handle the error here.
                        print(error)
                    }
                    DispatchQueue.main.async {
                        onboardingFinished = true
                    }
                }
            }
            
            Button("No, thanks") {
                onboardingFinished = true
            }
            .fontWeight(.semibold)
            .padding(.bottom)
            .accentColor(.secondaryContainer)
        }
    }
}

fileprivate struct PushNotificationHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    Text("Never miss")
                        .foregroundColor(.textWhite)
                    Text("an update")
                        .foregroundColor(.primaryDim)
                }
                .font(.chillaxMedium(size: 46))
                .kerning(-2.5)
                
                Spacer()
            }
            
            Text("Get push notifications about new proposals, votes, treasury movements, your delegates' activity, and more")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundColor(.textWhite)
                .font(.chillaxRegular(size: 17))
        }
    }
}

struct EnablePushNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        EnablePushNotificationsView()
    }
}
