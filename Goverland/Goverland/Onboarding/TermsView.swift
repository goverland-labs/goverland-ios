//
//  TermsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct TermsView: View {
    @Setting(\.termsAccepted) var termsAccepted
    @Setting(\.trackingAccepted) var trackingAccepted
    @Binding var termsViewIsPresented: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button {
                    termsViewIsPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 26))
                }
            }
            .padding(.top, 16)

            Spacer()
            
            Text("Understanding Our Practices")
                .fontWeight(.bold)
                .font(.title3)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 8) {
                    BulletedListsDot()
                    Text("To ensure the quality of our app, we collect anonymized app usage data and crash reports.")
                }
                
                HStack(alignment: .top, spacing: 8) {
                    BulletedListsDot()
                    Text("We respect your privacy: demographic data such as age or gender are not collected.")
                }
                
                HStack(alignment: .top, spacing: 8) {
                    BulletedListsDot()
                    Text("Learn more in our ") +
                    Text("[Privacy Policy](https://www.goverland.xyz/privacy)")
                        .underline() +
                    Text(" and ") +
                    Text("[Terms of Service.](https://www.goverland.xyz/terms)").underline()
                }
                .tint(.primaryDim)
            }

            Spacer()

            PrimaryButton("Get Started") {
                termsAccepted = true
                trackingAccepted = true
            }
            
            Button("Accept without sharing data") {
                termsAccepted = true
                trackingAccepted = false
            }
            .padding(.bottom, 16)
            .fontWeight(.medium)
            .tint(.primaryDim)
        }
        .padding(.horizontal, 16)
    }
}

fileprivate struct BulletedListsDot: View {
    var body: some View {
        Circle()
            .fill(Color.primaryDim)
            .frame(width: 8, height: 8)
            .padding(.top, 6)
    }
}
