//
//  IntroView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct IntroView: View {
    @Setting(\.termsAccepted) var termsAccepted

    var body: some View {
        VStack {
            Text("Intro View")
            Button("Accept") {
                termsAccepted = true
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
