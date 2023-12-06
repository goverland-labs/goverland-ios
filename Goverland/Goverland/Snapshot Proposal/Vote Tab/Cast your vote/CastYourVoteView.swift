//
//  CastYourVoteView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftData

struct CastYourVoteView: View {
    @StateObject private var model: CastYourVoteDataSource
    @Query private var profiles: [UserProfile]
    @Environment(\.dismiss) private var dismiss

    init(proposal: Proposal, choice: AnyObject) {
        self._model = StateObject(wrappedValue: CastYourVoteDataSource(proposal: proposal, choice: choice))        
    }

    private var vpSymbol: String {
        if let symbol = model.proposal.symbol, !symbol.isEmpty {
            return symbol
        }
        return "VOTE"
    }

    private var user: User {
        let profile = profiles.first(where: { $0.selected })!
        return User(address: Address(profile.address),
                    resolvedName: profile.resolvedName,
                    avatar: profile.avatar)
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
                IdentityView(user: user)                
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
                PrimaryButton("Sign", isEnabled: (model.validated ?? false) && !model.isPreparing) {
                    model.prepareVote(address: user.address.value)
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .onAppear {
            // TODO: track
            model.validate(address: user.address.value)
        }
    }
}
