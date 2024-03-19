//
//  SnapshotProposalVoteTabView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

enum SnapshotVoteTabType: Int, Identifiable {
    var id: Int { self.rawValue }

    case vote = 0
    case results
    case votes
    case info

    static var allTabs: [SnapshotVoteTabType] {
        return [.vote, .results, .votes, .info]
    }

    func localizedName(_ proposalState: Proposal.State) -> String {
        switch self {
        case .vote:
            return "Cast your vote"
        case .results:
            return proposalState == .active ? "Current results" : "Results"
        case .votes:
            return "Votes"
        case .info:
            return "Info"
        }
    }
}

struct SnapshotProposalVoteTabView: View {
    let proposal: Proposal
    @Namespace var namespace    
    @Setting(\.authToken) private var authToken

    @Query private var profiles: [UserProfile]
    @Query private var termsAgreements: [DaoTermsAgreement]

    @State private var chosenTab: SnapshotVoteTabType
    @State private var choice: AnyObject?
    @State private var voteButtonDisabled: Bool

    @State private var showSignIn = false
    @State private var showAgreeWithDaoTerms = false
    @State private var showVote = false
    @State private var showReconnectWallet = false

    init(proposal: Proposal) {
        self.proposal = proposal

        if proposal.state == .active || proposal.state == .pending {
            _chosenTab = State(wrappedValue: .vote)
        } else {
            _chosenTab = State(wrappedValue: .results)
        }

        // TODO: shutter completed proposals results are known. Need to improve.
        if let userVote = proposal.userVote, proposal.privacy != .shutter {
            // enumeration starts with 1 in Snapshot
            switch proposal.type {
            case .singleChoice, .basic:
                _choice = State(wrappedValue: (userVote.base as! Vote<Int>).choice - 1 as AnyObject)
            case .approval, .rankedChoice:
                _choice = State(wrappedValue: (userVote.base as! Vote<[Int]>).choice.map { $0 - 1 } as AnyObject)
            case .weighted, .quadratic:
                _choice = State(wrappedValue: (userVote.base as! Vote<[String: Int]>).choice as AnyObject)
            }
            _voteButtonDisabled = State(wrappedValue: false)
        } else {
            _voteButtonDisabled = State(wrappedValue: true)
        }
    }

    private var selectedProfile: UserProfile? {
        profiles.first(where: { $0.selected })
    }

    private var selectedProfileIsGuest: Bool {
        selectedProfile?.address.isEmpty ?? false
    }

    private var userAgreedWithDaoTerms: Bool {
        guard proposal.dao.terms != nil else { return true }
        if let found = termsAgreements.first(where: { $0.daoId == proposal.dao.id }) {
            if Date.now - ConfigurationManager.daoTermsAgreementRequestInterval > found.confirmationDate {
                return false
            }
            return true
        }
        return false
    }

    private var coinbaseWalletConnected: Bool {
        return CoinbaseWalletManager.shared.account != nil
    }

    private var wcSessionExistsAndNotExpired: Bool {
        if let sessionMeta = WC_Manager.shared.sessionMeta, !sessionMeta.isExpired {
            return true
        }
        logInfo("[WC] Session expiration date: \(WC_Manager.shared.sessionMeta?.session.expiryDate.toISO() ?? "NO SESSION")")
        return false
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SnapshotVoteTabType.allTabs) { tab in
                        if !skipTab(tab) {
                            ZStack {
                                if chosenTab == tab {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.secondaryContainer)
                                        .matchedGeometryEffect(id: "tab-background", in: namespace)
                                }
                                
                                Text(tab.localizedName(proposal.state))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .font(.caption2Semibold)
                                    .foregroundStyle(Color.onSecondaryContainer)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.secondaryContainer, lineWidth: 1)
                                    )
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5)) {
                                    self.chosenTab = tab
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            
            switch chosenTab {
            case .vote:
                switch proposal.type {
                case .basic: 
                    SnapshotBasicVotingView(voteButtonDisabled: $voteButtonDisabled, choice: $choice.asOptionalTypedBinding<Int>())
                case .singleChoice: 
                    SnapshotSingleChoiceVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled, choice: $choice.asOptionalTypedBinding<Int>())
                case .approval: 
                    SnapshotApprovalVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled, choice: $choice.asOptionalTypedBinding<[Int]>())
                case .rankedChoice: 
                    SnapshotRankedChoiceVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled, choice: $choice.asOptionalTypedBinding<[Int]>())
                case .weighted, .quadratic:
                    SnapshotWeightedVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled, choice: $choice.asOptionalTypedBinding<[String: Int]>())
                }

                if proposal.state == .active {
                    if authToken.isEmpty || selectedProfileIsGuest {
                        VoteButton(disabled: $voteButtonDisabled, title: "Sign in to vote") {
                            showSignIn = true
                        }
                    } else {
                        VoteButton(disabled: $voteButtonDisabled, title: "Vote") {
                            vote()
                        }
                    }
                }

            case .results:
                SnapshopVotingResultView(proposal: proposal)

            case .votes:
                if proposal.privacy == .shutter && proposal.state == .active {
                    // Votes are encrypted
                    SnapshotVotesView<String>(proposal: proposal)
                } else {
                    switch proposal.type {
                    case .basic, .singleChoice:
                        SnapshotVotesView<Int>(proposal: proposal)
                    case .approval, .rankedChoice:
                        SnapshotVotesView<[Int]>(proposal: proposal)
                    case .weighted, .quadratic:
                        SnapshotVotesView<[String: Int]>(proposal: proposal)
                    }
                }

            case .info:
                SnapshotProposalInfoView(proposal: proposal)
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView()
                .presentationDetents([.height(500), .large])
        }
        .sheet(isPresented: $showAgreeWithDaoTerms) {
            DaoTermsAgreementPopoverView(dao: proposal.dao) {
                vote()
            }
            .presentationDetents([.height(220), .large])
        }
        .sheet(isPresented: $showVote) {
            CastYourVoteView(proposal: proposal, choice: choice) {
                // TODO: check for achievements here
            }
            
        }
        .sheet(isPresented: $showReconnectWallet) {
            ReconnectWalletView(user: selectedProfile!.user)
        }
    }

    private func skipTab(_ tab: SnapshotVoteTabType) -> Bool {
        return (proposal.state == .pending && tab == .results) || (proposal.state != .active && tab == .vote)
    }

    private func vote() {
        Tracker.track(.snpDetailsVote)
        Haptic.medium()
        if !userAgreedWithDaoTerms {
            showAgreeWithDaoTerms = true
        } else if coinbaseWalletConnected || wcSessionExistsAndNotExpired {
            showVote = true
        } else {
            showReconnectWallet = true
        }
    }
}

extension Binding where Value == AnyObject? {
    func asOptionalTypedBinding<T>() -> Binding<T?> {
        Binding<T?>(
            get: {
                return self.wrappedValue as? T
            },
            set: { newValue in
                self.wrappedValue = newValue as AnyObject?
            }
        )
    }
}
