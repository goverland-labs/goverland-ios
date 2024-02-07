//
//  GuestAchievementsView().swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-07.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct GuestAchievementsView: View {
    var body: some View {
        VStack {
            Image("guest-profile-achieviments")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(height: 200)
                .padding(30)
            
            Text("Achievements are only available to signed in users")
                .font(.calloutRegular)
                .foregroundColor(.textWhite)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
        }
        
        Spacer()
    }
}

