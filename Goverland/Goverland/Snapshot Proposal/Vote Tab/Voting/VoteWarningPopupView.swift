//
//  VoteWarningPopupView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-09.
//

import SwiftUI

struct VoteWarningPopupView: View {
    let proposal: Proposal
    @Environment(\.openURL) var openURL
    @Binding var warningViewIsPresented: Bool
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    warningViewIsPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textWhite40)
                        .font(.system(size: 26))
                }
            }
            
            VStack(alignment: .center) {
                Text("Hmmm...")
                Text("Voting is Not Here Yet")
            }
            .font(.title3Semibold)
            .foregroundColor(.textWhite)
            
            Spacer()
            
            Text("We're developing in-app voting! Until it's ready, please use Snapshot website to cast your vote. Thanks for your patience!")
                .font(.bodyRegular)
                .foregroundColor(.textWhite)
                .padding(.bottom)

            PrimaryButton("Vote on Snapshot") {
                if let url = Utils.urlFromString(proposal.link) {
                    openURL(url)
                } else if let url = URL(string: "https://snapshot.org/#/\(proposal.dao.alias)/proposal/\(proposal.id)") {
                    openURL(url)
                } else {
                    openURL(URL(string: "https://snapshot.org")!)
                }
            }
        }
        .padding()
        .background(alignment: .top) {
            Image("proposal-vote-popup-background")
                .resizable()
                .scaledToFit()
        }
    }
}
