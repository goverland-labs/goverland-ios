//
//  IntroViewLoadingView.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-28.
//

import SwiftUI

struct IntroViewLoadingView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "timer.circle")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .foregroundColor(.white.opacity(0.6))
            HStack {
                Text("DAO")
                    .bold()
                Text("TRACKER")
            }
            .font(.title)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .edgesIgnoringSafeArea(.all)
    }
}

struct IntroViewLogoPreview_Previews: PreviewProvider {
    static var previews: some View {
        IntroViewLoadingView()
    }
}
