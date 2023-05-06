//
//  SnapshotProposalVoteTabView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-05-01.
//

import SwiftUI

enum BasicVoteTabType: Int, Identifiable {
    var id: Int { self.rawValue }

    case vote = 0
    case results
    case voters
    case info

    static var allFilters: [BasicVoteTabType] {
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
    @State var chosenTab: BasicVoteTabType = .vote
    @Namespace var namespace
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BasicVoteTabType.allFilters) { tab in
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
                BasicVotingView()
            case .results:
                Text("")
            case .voters:
                Text("")
            case .info:
                Text("")
            }
        }
    }
}

struct SnapshotProposaVoteTabView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotProposalVoteTabView()
    }
}
