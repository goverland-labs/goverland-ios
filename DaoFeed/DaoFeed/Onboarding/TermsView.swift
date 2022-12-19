//
//  TermsView.swift
//  DaoFeed
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct TermsView: View {
    @Setting(\.termsAccepted) var termsAccepted
    
    var body: some View {
        VStack {
            Spacer()
            Text("Here will be text with Terms")
            Spacer()
            Button("Accept") {
                termsAccepted = true
            }
        }.padding()
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
