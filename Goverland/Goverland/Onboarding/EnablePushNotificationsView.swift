//
//  EnablePushNotificationsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-16.
//  Copyright © Goverland Inc. All rights reserved.
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
            .padding(.horizontal)
            .onAppear() { Tracker.track(.screenPushNotifications) }
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
            
            Image("push-notifications-placeholder")
        }
    }
}

fileprivate struct PushNotificationFooterControlsView: View {
    @Setting(\.notificationsEnabled) var notificationsEnabled
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Enable notifications") {
                Tracker.track(.notificationsYes)
                NotificationsManager.shared.requestUserPermissionAndRegister { granted in
                    DispatchQueue.main.async {
                        notificationsEnabled = granted
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            Button("No, thanks") {
                Tracker.track(.notificationsNo)
                presentationMode.wrappedValue.dismiss()
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
            
            Text("Get push notifications about new proposals.")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundColor(.textWhite)
                .font(.chillaxRegular(size: 17))
        }        
    }
}
