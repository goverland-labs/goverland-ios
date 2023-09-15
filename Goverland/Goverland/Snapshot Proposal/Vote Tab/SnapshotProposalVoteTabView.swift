//
//  SnapshotProposalVoteTabView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

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

    @State var chosenTab: SnapshotVoteTabType = .vote
    @Namespace var namespace
    @Setting(\.onboardingFinished) var onboardingFinished
    @Environment(\.presentationMode) var presentationMode

    @State var voteButtonDisabled: Bool = true
    @State var warningViewIsPresented = false {
        didSet {
            if warningViewIsPresented {
                Tracker.track(.snpDetailsVote)
            }
        }
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SnapshotVoteTabType.allTabs) { tab in
                        if !(proposal.state == .pending && tab == .results) {
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
                                    .foregroundColor(.onSecondaryContainer)
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
                case .basic: SnapshotBasicVotingView(voteButtonDisabled: $voteButtonDisabled)
                case .singleChoice: SnapshotSingleChoiceVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled)
                case .approval: SnapshotApprovalVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled)
                case .rankedChoice: SnapshotRankedChoiceVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled)
                case .weighted, .quadratic : SnapshotWeightedVotingView(proposal: proposal, voteButtonDisabled: $voteButtonDisabled)
                }
                
                VoteButton(disabled: $voteButtonDisabled) {
                    warningViewIsPresented = true
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
        .sheet(isPresented: $warningViewIsPresented) {
            if onboardingFinished {
                VoteWarningPopupView(proposal: proposal, warningViewIsPresented: $warningViewIsPresented)
                    .presentationDetents([.medium, .large])
            } else {
                FinishOnboardingWarningView {
                    // Make it twice to come back to onboarding
                    presentationMode.wrappedValue.dismiss()
                    presentationMode.wrappedValue.dismiss()
                }
                    .presentationDetents([.medium, .large])
            }
        }
    }
}
