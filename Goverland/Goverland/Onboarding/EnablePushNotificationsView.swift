//
//  EnablePushNotificationsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-16.
//

import SwiftUI

struct EnablePushNotificationsView: View {
    @Setting(\.onboardingFinished) var onboardingFinished
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("pushNotifications")
                    .resizable()
                    .aspectRatio(CGSize(width: 1548, height: 460), contentMode: .fit)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height * 3 / 5,
                           alignment: .center)
                
                VStack(spacing: 20) {
                    Text("Never miss an update")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Get push notifications about new proposales, votes, treasury movements, your delegates, activity, and more.")
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.bottom)
                    
                    Button("Enable notifications") {
                        let center = UNUserNotificationCenter.current()
                        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                            if let error = error {
                                // Handle the error here.
                                print(error)
                            }
                            // Enable or disable features based on the authorization.
                            onboardingFinished = true
                        }
                    }
                    .ghostActionButtonStyle()
                    
                    Button("No, thanks") {
                        onboardingFinished = true
                    }
                    .fontWeight(.semibold)
                    .padding(.bottom)
                }
                .frame(width: geometry.size.width * 0.9,
                       height: geometry.size.height * 2 / 5,
                       alignment: .center)
            }
        }
    }
}

struct EnablePushNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        EnablePushNotificationsView()
    }
}
