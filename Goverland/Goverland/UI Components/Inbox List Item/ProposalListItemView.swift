//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalListItemNoElipsisView: View {
    let proposal: Proposal
    let isSelected: Bool
    let isRead: Bool
    let isPresented: Bool
    let isHighlighted: Bool
    let onDaoTap: (() -> Void)?

    @Environment(\.isPresented) private var _isPresented

    init(proposal: Proposal,
         isSelected: Bool = false,
         isRead: Bool = false,
         isPresented: Bool = false,
         isHighlighted: Bool = false,
         onDaoTap: (() -> Void)? = nil) {
        self.proposal = proposal
        self.isSelected = isSelected
        self.isRead = isRead
        self.isPresented = isPresented
        self.isHighlighted = isHighlighted
        self.onDaoTap = onDaoTap
    }

    private var backgroundColor: Color {
        if isSelected {
            return .secondaryContainer
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            return .containerBright
        }

        if isPresented || _isPresented {            
            return .containerBright
        }

        return .container
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .stroke(isHighlighted ? Color.secondaryContainer : .clear, lineWidth: 1)


            VStack(spacing: 12) {
                ProposalListItemHeaderView(proposal: proposal)
                ProposalListItemBodyView(proposal: proposal, displayStatus: true, onDaoTap: onDaoTap)
                VoteFooterView(votes: proposal.votes,
                               votesHighlighted: proposal.state == .active,
                               quorum: proposal.quorum,
                               quorumHighlighted: proposal.quorum >= 100)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, 12)

            if isRead && !isSelected {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.containerDim.opacity(0.6))
                    .allowsHitTesting(false)
            }
        }
    }
}

struct ProposalListItemView<Content: View>: View {
    let proposal: Proposal
    let isSelected: Bool
    let isRead: Bool
    let onDaoTap: (() -> Void)?
    let menuContent: Content

    @Environment(\.isPresented) private var isPresented

    init(proposal: Proposal,
         isSelected: Bool,
         isRead: Bool,
         onDaoTap: (() -> Void)? = nil,
         @ViewBuilder menuContent: () -> Content) {
        self.proposal = proposal
        self.isSelected = isSelected
        self.isRead = isRead
        self.onDaoTap = onDaoTap
        self.menuContent = menuContent()
    }

    var body: some View {
        ZStack {
            ProposalListItemNoElipsisView(proposal: proposal,
                                          isSelected: isSelected,
                                          isRead: isRead,
                                          isPresented: isPresented,
                                          onDaoTap: onDaoTap)

            // Place Menu into botter right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // TODO: Magic. Using HStack here crashes the app. With LazyVStack app doesn't crash,
                    // but it still glitches a bit and there are errors in the console:
                    // List failed to visit cell content, returning an empty cell.
                    LazyVStack(alignment: .trailing) {
                        Menu {
                            menuContent
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color.textWhite40)
                                .fontWeight(.heavy)
                                .frame(width: 56, height: 40)
                        }
                    }
                }
            }
        }
    }
}

struct ProposalListItemHeaderView: View {
    let proposal: Proposal
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    private var voted: Bool {
        proposal.userVote != nil
    }

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: proposal.author) {
                    activeSheetManager.activeSheet = .publicProfile(proposal.author.address)
                    // TODO: track
                }
                DateView(date: proposal.created,
                         style: .named,
                         font: .footnoteRegular,
                         color: .textWhite40)
            }

            Spacer()
            HStack(spacing: 6) {
                if voted {
                    BubbleView(
                        image: Image(systemName: "checkmark"),
                        text: nil,
                        textColor: .onSecondaryContainer,
                        backgroundColor: .secondaryContainer)
                }
                ProposalStatusView(state: proposal.state)
            }
        }
    }
}

struct ProposalListItemBodyView: View {
    let proposal: Proposal
    let displayStatus: Bool
    let onDaoTap: (() -> Void)?

    var shouldShowVoteChoice: Bool {
        Utils.userChoice(from: proposal) != nil || Utils.publicUserChoice(from: proposal) != nil
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(proposal.title)
                    .foregroundStyle(Color.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)

                if displayStatus {
                    if shouldShowVoteChoice {
                        VStack(alignment: .leading, spacing: 4) {
                            if let publicUserChoice = Utils.publicUserChoice(from: proposal) {
                                // public user voted
                                let choiceStr = Utils.choiseAsStr(proposal: proposal, choice: publicUserChoice)
                                Text("User choice: \(choiceStr)")
                            }

                            if let userChoice = Utils.userChoice(from: proposal) {
                                // user voted
                                let choiceStr = Utils.choiseAsStr(proposal: proposal, choice: userChoice)
                                Text("Your choice: \(choiceStr)")
                            }
                        }
                        .foregroundStyle(proposal.state == .active ? Color.primaryDim : .textWhite40)
                        .font(.footnoteRegular)
                        .lineLimit(2)
                    } else {
                        HStack(spacing: 0) {
                            Text(proposal.votingEnd.isInPast ? "Vote finished " : "Vote finishes ")
                                .foregroundStyle(proposal.state == .active ? Color.primaryDim : .textWhite40)
                                .font(.footnoteRegular)
                                .lineLimit(1)

                            DateView(date: proposal.votingEnd,
                                     style: .numeric,
                                     font: .footnoteRegular,
                                     color: proposal.state == .active ? .primaryDim : .textWhite40)
                        }
                    }
                }
            }

            Spacer()
            RoundPictureView(image: proposal.dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                .allowsHitTesting(onDaoTap == nil ? false : true)
                .onTapGesture {
                    onDaoTap?()
                }
        }
    }
}

fileprivate struct VoteFooterView: View {
    let votes: Int
    let votesHighlighted: Bool
    let quorum: Int
    let quorumHighlighted: Bool

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                Text(Utils.formattedNumber(Double(votes)))
            }
            .font(.footnoteRegular)
            .foregroundStyle(votesHighlighted ? Color.textWhite : .textWhite40)

            if quorum > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "flag.checkered")
                    Text(Utils.numberWithPercent(from: quorum))
                }
                .font(.footnoteRegular)
                .foregroundStyle(quorumHighlighted ? Color.textWhite : .textWhite40)
            }

            Spacer()
        }
    }
}

struct ShimmerProposalListItemView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)

            VStack(spacing: 12) {
                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 180)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 90)
                }
                .frame(height: 20)

                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 250)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(Avatar.Size.m.daoImageSize / 2)
                        .frame(width: Avatar.Size.m.daoImageSize, height: Avatar.Size.m.daoImageSize)
                }
                .frame(height: 50)

                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 100)
                    Spacer()
                }
                .frame(height: 20)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.horizontalPadding / 2)
        }
        .frame(height: 142)
    }
}
