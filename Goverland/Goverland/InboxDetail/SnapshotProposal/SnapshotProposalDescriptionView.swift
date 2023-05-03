//
//  SnapshotProposalDescriptionView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

struct SnapshotProposalDescriptionView: View {
    var body: some View {
        VStack {
            Text("GIP-77 proposed to both add improved delegation to the Gnosis DAO and to take measures to reduce spam in the GnosisDAO snapshot space. While implementation for the former is still underway, a recent update to Snapshot now allows spaces to define moderators who are able to hide spam proposals without having admin control over other sensitive settings in the Snapshot")
                .font(.headlineRegular)
                .foregroundColor(.textWhite)
                .overlay(shadowOverlay(), alignment: .bottom)
            
            Button("Read more") {
                print("reading")
            }
            .ghostReadMoreButtonStyle()
        }
    }
}

fileprivate struct shadowOverlay: View {
    var body: some View {
        Rectangle().fill(
            LinearGradient(colors: [.clear, .surface.opacity(0.8)],
                           startPoint: .top,
                           endPoint: .bottom))
        .frame(height: 50)
    }
}

struct SnapshotProposaDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalDescriptionView()
    }
}
