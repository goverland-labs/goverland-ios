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
    @StateObject private var activeSheetManager: ActiveSheetManager

    init(proposal: Proposal, choice: AnyObject?, onSuccess: @escaping () -> Void) {
        _dataSource = StateObject(wrappedValue: CastYourVoteDataSource(proposal: proposal, choice: choice, onSuccess: onSuccess))
        _activeSheetManager = StateObject(wrappedValue: ActiveSheetManager())
    }
    
    var body: some View {
        if dataSource.submitted {
            _SuccessView(proposal: dataSource.proposal, choice: dataSource.choiceStr, reason: dataSource.reason)
        } else {
            _VoteView(dataSource: dataSource)
                .overlay {
                    // we need it to espace crashes inside ToastView
                    ToastView()
                        .environmentObject(activeSheetManager)
                }
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
        return profile.user
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
                                    .foregroundStyle(Color.textWhite)
                                    .tint(.textWhite40)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.containerBright)
                                    .cornerRadius(20)
                                
                                // TextEditor doesn't have a placeholder support yet
                                if !isTextEditorFocused && dataSource.reason.isEmpty {
                                    Text("Share your reason (optional)")
                                        .allowsHitTesting(false)
                                        .foregroundStyle(Color.textWhite20)
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
                                InfoMessageView(message: message)
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
                            Haptic.medium()
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
            Tracker.track(.screenSnpCastVote)
            dataSource.validate(address: user.address.value)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

fileprivate struct _HeaderView: View {
    @ObservedObject var dataSource: CastYourVoteDataSource
    let user: User
    
    private var vpSymbol: String {
        if let symbol = dataSource.proposal.symbol, !symbol.isEmpty {
            return symbol
        }
        return "VOTE"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Cast your vote")
                .foregroundStyle(Color.textWhite)
                .font(.title3Semibold)
            
            Image("cast-your-vote")
                .padding(.vertical, 32)
                .frame(width: 186)
                .scaledToFit()
            
            HStack {
                Text("Selected wallet")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite)

                Spacer()
                
                if let walletImage = WC_Manager.shared.sessionMeta?.walletImage {
                    walletImage
                        .frame(width: Avatar.Size.s.profileImageSize, height: Avatar.Size.s.profileImageSize)
                        .scaledToFit()
                        .clipShape(Circle())
                } else if let walletImageUrl = WC_Manager.shared.sessionMeta?.walletImageUrl {
                    RoundPictureView(image: walletImageUrl, imageSize: Avatar.Size.s.profileImageSize)
                }

                IdentityView(user: user, size: .s, onTap: nil)
            }
            
            HStack {
                Text("Voting power")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                Text("\(Utils.formattedNumber(dataSource.votingPower)) \(vpSymbol)")
                    .font(.bodySemibold)
                    .foregroundStyle(Color.textWhite)
            }
            
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.secondaryContainer)
                .frame(height: 1)
                .padding(.vertical, 8)

            HStack {
                Text("Choice")
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                Text(dataSource.choiceStr)
                    .font(.bodySemibold)
                    .foregroundStyle(Color.textWhite)
            }
            
            HStack {
                Text("Validation")
                Spacer()
                
                if dataSource.failedToValidate {
                    Text("-")
                        .foregroundStyle(Color.textWhite)
                } else if dataSource.validated == nil { // validation in progress
                    ProgressView()
                        .foregroundStyle(Color.textWhite20)
                        .controlSize(.mini)
                } else if dataSource.validated! {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.primaryDim)
                        .font(.bodySemibold)
                } else {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.dangerText)
                        .font(.bodySemibold)
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
                    .foregroundStyle(Color.dangerText)
                Text(message)
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite)
            }
            .padding(.leading, 8)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.containerBright)
        }
        .padding(.top, 24)
    }
}

fileprivate struct _SuccessView: View {
    let proposal: Proposal
    let choice: String
    let reason: String?
    @Environment(\.dismiss) private var dismiss
    @Setting(\.lastSuggestedToRateTime) private var lastSuggestedToRateTime
    @StateObject private var orientationManager = DeviceOrientationManager.shared

    private var scaleRatio: Double {
        if orientationManager.currentOrientation.isLandscape {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 0 // hide animation
            } else {
                return 1/3
            }
        } else {
            return 3/5
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    Text("Your vote is in!")
                        .foregroundStyle(Color.textWhite)
                        .font(.title3Semibold)

                    Spacer()

                    SuccessVoteLottieView()
                        .frame(width: geometry.size.width * scaleRatio, height: geometry.size.width * scaleRatio)
                        .id(orientationManager.currentOrientation)

                    Spacer()

                    Text("Votes can be changed while the proposal is active")
                        .foregroundStyle(Color.textWhite60)
                        .font(.footnoteRegular)

                    VStack(spacing: 16) {
                        SecondaryButton("Share on X") {
                            let postText = messageToShare()
                            let postUrl = postText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                            if let url = URL(string: "https://x.com/intent/tweet?text=\(postUrl)") {
                                Haptic.medium()
                                openUrl(url)
                            }
                            Tracker.track(.snpSuccessVoteShareX)
                        }

                        SecondaryButton("Share on Warpcast") {
                            let castText = messageToShare()
                            let castUrl = castText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                            let warpcastUrl = URL(string: "https://warpcast.com/~/compose?text=\(castUrl)")
                            if let url = warpcastUrl {
                                Haptic.medium()
                                openUrl(url)
                            }
                            Tracker.track(.snpSuccessVoteShareWarpcast)
                        }

                        PrimaryButton("Done") {
                            Haptic.medium()
                            dismiss()

                            let now = Date().timeIntervalSinceReferenceDate
                            if now - lastSuggestedToRateTime > ConfigurationManager.suggestToRateRequestInterval {
                                if let scene = UIApplication.shared.connectedScenes
                                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                                {
                                    SKStoreReviewController.requestReview(in: scene)
                                    lastSuggestedToRateTime = now
                                    Tracker.track(.snpVoteShowRateApp)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                }
                // this is needed as on iPad GeometryReader breaks VStack layout
                .frame(maxWidth: geometry.size.width - Constants.horizontalPadding * 2, minHeight: geometry.size.height - 50)
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.bottom, 16)
                .padding(.top, 24)
                .onAppear {
                    Tracker.track(.screenSnpVoteSuccess)
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    func messageToShare() -> String {
        var message =
                    """
I just voted in \(proposal.dao.name) using the Goverland Mobile App! 🚀
Proposal: \(proposal.title)
My choice: \(choice)
"""
        if let reason, !reason.isEmpty {
            message += "\nReason: \(reason)"
        }
        message += "\n\(proposal.goverlandUrl.absoluteString)"
        return message
    }
}
