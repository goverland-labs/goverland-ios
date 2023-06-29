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
    case voters
    case info

    static var allTabs: [SnapshotVoteTabType] {
        return [.vote, .results, .voters, .info]
    }

    var localizedName: String {
        switch self {
        case .vote:
            return "Cust your vote"
        case .results:
            return "Current results"
        case .voters:
            return "Voters"
        case .info:
            return "Info"
        }
    }
}

struct SnapshotProposalVoteTabView: View {
    let proposal: Proposal

    @State var chosenTab: SnapshotVoteTabType = .vote
    @Namespace var namespace
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SnapshotVoteTabType.allTabs) { tab in
                        ZStack {
                            if chosenTab == tab {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.secondaryContainer)
                                    .matchedGeometryEffect(id: "tab-background", in: namespace)
                            }
                            Text(tab.localizedName)
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
                            // API goes here
                        }
                    }
                }
                .padding(.bottom)
            }
            
            switch chosenTab {
            case .vote:
                // TODO: implement views for every vote type
                switch proposal.type {
                case .basic: SnapshotBasicVotingView { index in
                    print("Selected option # \(index + 1)")
                }
                case .singleChoice: SnapshotSingleChoiceVotingView(proposal: proposal) { index in
                    print("Selected option # \(index + 1)")
                }
                case .approval: SnapshotApprovalVotingView(proposal: proposal)
                default: SnapshotBasicVotingView { _ in }
                }
            case .results:
                switch proposal.type {
                case .basic: SnapshotBasicVotingResultView(proposal: proposal)
                case .singleChoice: SnapshotSingleChoiceVotingResultView(proposal: proposal)
                case .approval: SnapshotApprovalVotingResultView(proposal: proposal)
                default: SnapshotBasicVotingResultView(proposal: proposal)
                }
            case .voters:
                SnapshotVotersView()
            case .info:
                SnapshotProposalInfoView(proposal: proposal)
            }
        }
    }
}

struct SnapshotProposaVoteTabView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalVoteTabView(proposal: .aaveTest)
    }
}
