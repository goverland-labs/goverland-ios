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
        Spacer()
        Text("Enable Push Notifications View")
        Spacer()
        Button("Finish onboarding") {
            onboardingFinished = true
        }.padding()
    }
}

struct EnablePushNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        EnablePushNotificationsView()
    }
}
