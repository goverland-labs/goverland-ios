//
//  PartnershipSettingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//

import SwiftUI

struct PartnershipSettingView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: -15) {
                Text("Let's")
                Text("Collaborate!")
            }
            .foregroundColor(.textWhite)
            .font(.chillaxMedium(size: 46))
            .kerning(-2.5)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("For potential partnership discussions, feel free to reach out to us on our Discord or drop us an email at partnership@goverland.xyz.")
                Text("We're excited to explore possibilities with you!")
            }
            .lineLimit(5)
            .multilineTextAlignment(.leading)
            .foregroundColor(.textWhite)
            .font(.chillaxRegular(size: 17))
            
            Spacer()
            
            PrimaryButton("Visit Website") {
                openURL(URL(string: "https://www.goverland.xyz/")!)
            }
        }
        .padding()
        .background (
            VStack {
                Spacer()
                Image("settings-partnership-background")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 50)
            }
        )
    }
}

struct PartnershipSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PartnershipSettingView()
    }
}
