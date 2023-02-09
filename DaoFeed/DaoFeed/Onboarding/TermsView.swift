//
//  TermsView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct TermsView: View {
    @Setting(\.termsAccepted) var termsAccepted
    @Binding var termsViewIsPresented: Bool
    
    var body: some View {
        
        VStack(spacing: 30) {
           
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
            
            Text("Terms Of Use and Privacy Policy")
                .fontWeight(.bold)
                .font(.title3)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 10) {
                    BulletedListsDot()
                    Text("We collect anonymized app usage data and crash reports to ensure the quality of our app.")
                }
                
                HStack(alignment: .top, spacing: 10) {
                    BulletedListsDot()
                    Text("We do not collect demographic data such as age or gander")
                }
                
                HStack(alignment: .top, spacing: 10) {
                    BulletedListsDot()
                    Text("Read more in ") +
                    Text("[Privacy Policy](https://google.com)")
                        .underline() +
                    Text(" and ") +
                    Text("[Terms](https://google.com)").underline()
                }
            }
            
            Button("Get Started") {
                termsAccepted = true
            }
            .ghostActionButtonStyle()
            
            Button("Accept without sharing data") {
                termsAccepted = true
            }
            .fontWeight(.medium)
            
        }.padding(.horizontal, 30)
    }
}

fileprivate struct BulletedListsDot: View {
    var body: some View {
        Circle()
            .fill(.black)
            .frame(width: 8, height: 8)
            .padding(.top, 6)
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(termsViewIsPresented: .constant(true))
    }
}
