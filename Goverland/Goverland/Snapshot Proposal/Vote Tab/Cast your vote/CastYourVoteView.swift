//
//  CastYourVoteView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct CastYourVoteView: View {
    @StateObject private var model: CastYourVoteModel
    @Environment(\.dismiss) private var dismiss

    init(proposal: Proposal, choice: AnyObject) {
        self._model = StateObject(wrappedValue: CastYourVoteModel(proposal: proposal, choice: choice))        
    }

    var vpSymbol: String {
        if let symbol = model.proposal.symbol, !symbol.isEmpty {
            return symbol
        }
        return "VOTE"
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Cast your vote")
                .foregroundStyle(Color.textWhite)
                .font(.title3Semibold)
            HStack {
                Text("Account")
                    .foregroundStyle(Color.textWhite)
                Spacer()
                // TODO: use IdentityView with a User oject within a cached Profile object
                // TODO: session might be not there, so connecting wallet would be required
                Text(model.voter)
            }

            HStack {
                Text("Voting power")
                    .foregroundStyle(Color.textWhite)
                Spacer()
                Text("\(model.votingPower) \(vpSymbol)" )
                    .foregroundStyle(Color.textWhite)
            }

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryContainer)
                .frame(height: 2)

            HStack {
                Text("Choice")
                    .foregroundStyle(Color.textWhite)
                Spacer()
                Text(model.choiceStr)
                    .foregroundStyle(Color.textWhite)
            }

            HStack {
                Text("Validation")
                Spacer()

                if model.failedToValidate {
                    Text("-")
                        .foregroundStyle(Color.textWhite)
                } else if model.validated == nil { // validation in progress
                    ProgressView()
                        .foregroundColor(.textWhite20)
                        .controlSize(.mini)
                } else if model.validated! {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.primaryDim)
                } else {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.dangerText)
                }
            }

            if let errorMessage = model.errorMessage {
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.dangerText)
                        Text(errorMessage)
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textWhite)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                }
                .background {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.containerBright)
                }
                .padding(.top, 24)
            }

            Spacer()

            HStack(spacing: 16) {
                SecondaryButton("Cancel") {
                    dismiss()
                }
                PrimaryButton("Confirm", isEnabled: (model.validated ?? false) && !model.isPreparing) {
                    model.prepareVote()
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .onAppear {
            // TODO: track
            model.validate()
        }
    }
}
