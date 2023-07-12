//
//  TermsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
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
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
            }
            
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
                .accentColor(.primaryDim)
            }

            PrimaryButton("Get Started") {
                termsAccepted = true
                trackingAccepted = true
            }
            
            Button("Accept without sharing data") {
                termsAccepted = true
            }
            .fontWeight(.medium)
            .accentColor(.primaryDim)
            
        }
        .padding(.horizontal, 16)
    }
}

fileprivate struct BulletedListsDot: View {
    var body: some View {
        Circle()
            .fill(.primary)
            .frame(width: 8, height: 8)
            .padding(.top, 6)
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(termsViewIsPresented: .constant(true))
    }
}
