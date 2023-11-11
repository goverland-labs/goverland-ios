//
//  CustYourVoteView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct CustYourVoteView: View {
    @StateObject private var model: CustYourVoteModel
    @Environment(\.dismiss) private var dismiss

    init(proposal: Proposal) {
        self._model = StateObject(wrappedValue: CustYourVoteModel(proposal: proposal))
    }

    var body: some View {
        VStack {
            Text("Cust your vote")
            HStack {
                Text("Account")
                Spacer()
                // TODO: use IdentityView with a User oject within a cached Profile object
                // TODO: session might be not there, so connecting wallet would be required
                Text(model.voter)
            }

            HStack {
                Text("Voting power")
                Spacer()
                Text("\(model.votingPower) \(model.proposal.symbol ?? "VOTE")" )
            }

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryContainer)
                .frame(height: 2)

            HStack {
                Text("Validation")
                Spacer()

                if model.valid == nil { // validation in progress
                    ProgressView()
                        .foregroundColor(.textWhite20)
                        .controlSize(.mini)
                } else if model.valid! {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.primaryDim)
                } else {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.dangerText)
                }
            }
        }
        .onAppear {
            // TODO: track
            model.validate()
        }
    }

}
