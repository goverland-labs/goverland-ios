//
//  IntroView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct IntroView: View {    
    @State var termsViewIsPresented = false

    var body: some View {
        VStack {
            Spacer()
            Text("Intro View")
            Spacer()
            Button("Start") {
                termsViewIsPresented = true
            }
        }.sheet(isPresented: $termsViewIsPresented) {
            TermsView()
                .presentationDetents([.medium, .large])
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
