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

    init(proposal: Proposal, choice: AnyObject?, onSuccess: @escaping () -> Void) {
        self._model = StateObject(wrappedValue: CastYourVoteDataSource(proposal: proposal, choice: choice, onSuccess: onSuccess))
    }

    var body: some View {
        if model.submitted {
            _SuccessView()
        } else {
            _VoteView(model: model)
        }
    }
}

fileprivate struct _VoteView: View {
    @StateObject var model: CastYourVoteDataSource
    @Query private var profiles: [UserProfile]
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextEditorFocused: Bool

    let bottomElementId = UUID()

    private var user: User {
        let profile = profiles.first(where: { $0.selected })!
        return User(address: Address(profile.address),
                    resolvedName: profile.resolvedName,
                    avatar: profile.avatar)
    }

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        _HeaderView(model: model, user: user)

                        // Reason Text Input

                        if (model.validated ?? false) && !model.isShieldedVoting {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $model.reason)
                                    .focused($isTextEditorFocused)
                                    .frame(height: 96)
                                    .foregroundColor(.textWhite)
                                    .accentColor(.textWhite40)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.containerBright)
                                    .cornerRadius(20)

                                // TextEditor doesn't have a placeholder support yet
                                if !isTextEditorFocused && model.reason.isEmpty {
                                    Text("Share your reason (optional)")
                                        .allowsHitTesting(false)
                                        .foregroundColor(.textWhite20)
                                        .padding(16)
                                }
                            }
                            .padding(.top, 16)
                        }

                        // Error message

                        if let errorMessage = model.errorMessage {
                            _ErrorMessageView(message: errorMessage)
                        }

                        Spacer()

                        // Info message

                        Group {
                            if let message = model.infoMessage {
                                _InfoMessageView(message: message)
                            } else {
                                Spacer()
                            }
                        }
                        .id(bottomElementId)
                        .padding(.bottom, 74)
                    }
                }
                .scrollIndicators(.hidden)
                .onTapGesture {
                    // To hide keyboard when tapping outside of TextEditor
                    isTextEditorFocused = false
                }
                .onChange(of: isTextEditorFocused) {
                    if isTextEditorFocused {
                        // Initially the system scrolls to the TextEditor, then we scroll to the bottom `Group`
                        // element to make buttons visible and not layered on top of other elements.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation {
                                proxy.scrollTo(bottomElementId)
                            }
                        }
                    }
                }
            }

            // Attach buttons to the bottom of the screen
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 16) {
                        SecondaryButton("Cancel") {
                            dismiss()
                        }
                        PrimaryButton("Sign",
                                      isEnabled: (model.validated ?? false) && !model.isPreparing && !model.isSubmitting) {
                            model.prepareVote(address: user.address.value)
                            isTextEditorFocused = false
                        }
                    }
                    .padding(.top, 16)
                }
                .background(Color(UIColor.systemBackground))
            }
        }
        .onAppear {
            // TODO: track
            model.validate(address: user.address.value)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)

    }
}

fileprivate struct _HeaderView: View {
    @StateObject var model: CastYourVoteDataSource
    let user: User

    private var vpSymbol: String {
        if let symbol = model.proposal.symbol, !symbol.isEmpty {
            return symbol
        }
        return "VOTE"
    }

    var body: some View {
        VStack {
            Text("Cast your vote")
                .foregroundColor(.textWhite)
                .font(.title3Semibold)

            Image("cast-your-vote")
                .padding(.vertical, 32)
                .frame(width: 186)
                .scaledToFit()

            HStack {
                Text("Account")
                    .foregroundColor(.textWhite)
                Spacer()
                IdentityView(user: user)
            }

            HStack {
                Text("Voting power")
                    .foregroundColor(.textWhite)
                Spacer()
                Text("\(model.votingPower) \(vpSymbol)" )
                    .foregroundColor(.textWhite)
            }

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryContainer)
                .frame(height: 2)

            HStack {
                Text("Choice")
                    .foregroundColor(.textWhite)
                Spacer()
                Text(model.choiceStr)
                    .foregroundColor(.textWhite)
            }

            HStack {
                Text("Validation")
                Spacer()

                if model.failedToValidate {
                    Text("-")
                        .foregroundColor(.textWhite)
                } else if model.validated == nil { // validation in progress
                    ProgressView()
                        .foregroundColor(.textWhite20)
                        .controlSize(.mini)
                } else if model.validated! {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primaryDim)
                } else {
                    Image(systemName: "xmark")
                        .foregroundColor(.dangerText)
                }
            }
        }
    }
}

fileprivate struct _ErrorMessageView: View {
    let message: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.dangerText)
                Text(message)
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
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
}

fileprivate struct _InfoMessageView: View {
    let message: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.textWhite)
                Text(message)
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.containerBright)
        }
    }
}

fileprivate struct _SuccessView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Your vote is in!")
                .foregroundColor(.textWhite)
                .font(.title3Semibold)

            Spacer()

            Text("Votes can be changed while the proposal is active")
                .foregroundColor(.textWhite60)
                .font(.footnoteRegular)

            VStack(spacing: 16) {
                SecondaryButton("Share on X") {
                    // TODO: implement
                }
                PrimaryButton("Done") {
                    dismiss()
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .onAppear {
            // TODO: track
        }
    }
}
