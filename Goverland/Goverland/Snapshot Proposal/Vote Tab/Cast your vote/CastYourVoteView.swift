//
//  CastYourVoteView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//


import SwiftUI
import SwiftData
import StoreKit

struct CastYourVoteView: View {
    @StateObject private var dataSource: CastYourVoteDataSource
    
    init(proposal: Proposal, choice: AnyObject?, onSuccess: @escaping () -> Void) {
        self._dataSource = StateObject(wrappedValue: CastYourVoteDataSource(proposal: proposal, choice: choice, onSuccess: onSuccess))
    }
    
    var body: some View {
        if dataSource.submitted {
            _SuccessView(proposal: dataSource.proposal, choice: dataSource.choiceStr, reason: dataSource.reason)
        } else {
            _VoteView(dataSource: dataSource)
        }
    }
}

fileprivate struct _VoteView: View {
    @StateObject var dataSource: CastYourVoteDataSource
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
                        _HeaderView(dataSource: dataSource, user: user)
                        
                        // Reason Text Input
                        
                        if (dataSource.validated ?? false) && !dataSource.isShieldedVoting {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $dataSource.reason)
                                    .focused($isTextEditorFocused)
                                    .frame(height: 96)
                                    .foregroundColor(.textWhite)
                                    .accentColor(.textWhite40)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.containerBright)
                                    .cornerRadius(20)
                                
                                // TextEditor doesn't have a placeholder support yet
                                if !isTextEditorFocused && dataSource.reason.isEmpty {
                                    Text("Share your reason (optional)")
                                        .allowsHitTesting(false)
                                        .foregroundColor(.textWhite20)
                                        .padding(16)
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        // Error message
                        
                        if let errorMessage = dataSource.errorMessage {
                            _ErrorMessageView(message: errorMessage)
                        }
                        
                        Spacer()
                        
                        // Info message
                        
                        Group {
                            if let message = dataSource.infoMessage {
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
                                      isEnabled: (dataSource.validated ?? false) && !dataSource.isPreparing && !dataSource.isSubmitting) {
                            dataSource.prepareVote(address: user.address.value)
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
            dataSource.validate(address: user.address.value)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

fileprivate struct _HeaderView: View {
    @StateObject var dataSource: CastYourVoteDataSource
    let user: User
    
    private var vpSymbol: String {
        if let symbol = dataSource.proposal.symbol, !symbol.isEmpty {
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
                Text("\(dataSource.votingPower) \(vpSymbol)" )
                    .foregroundColor(.textWhite)
            }
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryContainer)
                .frame(height: 2)
            
            HStack {
                Text("Choice")
                    .foregroundColor(.textWhite)
                Spacer()
                Text(dataSource.choiceStr)
                    .foregroundColor(.textWhite)
            }
            
            HStack {
                Text("Validation")
                Spacer()
                
                if dataSource.failedToValidate {
                    Text("-")
                        .foregroundColor(.textWhite)
                } else if dataSource.validated == nil { // validation in progress
                    ProgressView()
                        .foregroundColor(.textWhite20)
                        .controlSize(.mini)
                } else if dataSource.validated! {
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
    let proposal: Proposal
    let choice: String
    let reason: String?
    @Environment(\.dismiss) private var dismiss
    @Setting(\.lastSuggestedToRateTime) private var lastSuggestedToRateTime
    
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
                    var tweetText = """
I just voted in \(proposal.dao.name) using the Goverland Mobile App! 🚀
Proposal: \(proposal.title)
My choice: \(choice)
"""
                    if let reason {
                        tweetText += "\nMy reason: \(reason)"
                    }

                    let tweetUrl = tweetText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    let twitterUrl = URL(string: "https://x.com/intent/tweet?text=\(tweetUrl ?? "")")
                    
                    if let url = twitterUrl {
                        openUrl(url)
                    }
                    // TODO: track
                }
                PrimaryButton("Done") {
                    dismiss()
                    
                    let now = Date().timeIntervalSinceReferenceDate
                    if now - lastSuggestedToRateTime > ConfigurationManager.suggestToRateRequestInterval {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                            lastSuggestedToRateTime = now
                        }
                    }
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
