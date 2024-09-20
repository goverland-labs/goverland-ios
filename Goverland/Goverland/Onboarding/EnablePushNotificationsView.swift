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
                .foregroundStyle(Color.clear)
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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            PrimaryButton("Enable notifications") {
                Haptic.medium()
                Tracker.track(.notificationsYes)
                NotificationsManager.shared.requestUserPermissionAndRegister { granted in
                    DispatchQueue.main.async {
                        notificationsEnabled = granted
                        dismiss()
                        if !granted, let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            showInfoAlert(
"""
### ⚠️ Action required! 
To receive notifications, please enable them in your [device settings](\(settingsURL.absoluteString))
"""
                            )
                            offerToEnableNotificationsOnNextEligibleAction()
                        }
                    }
                }
            }
            
            Button("No, thanks") {
                Tracker.track(.notificationsNo)
                dismiss()
            }
            .fontWeight(.semibold)
            .padding(.bottom)
            .tint(.secondaryContainer)
        }
    }
}

fileprivate struct PushNotificationHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    Text("Never miss")
                        .foregroundStyle(Color.textWhite)
                    Text("an update")
                        .foregroundStyle(Color.primaryDim)
                }
                .font(.chillaxMedium(size: 46))
                .kerning(-2.5)
                
                Spacer()
            }
            
            Text("Get push notifications about new proposals.")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.textWhite)
                .font(.chillaxRegular(size: 17))
        }        
    }
}
