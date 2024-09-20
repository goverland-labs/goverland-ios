//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

enum ProposalListItemViewPublicUserContext {
    case publicUser
    case delegate
}

struct ProposalListItemView: View {
    let proposal: Proposal
    let isSelected: Bool
    let isRead: Bool
    let isPresented: Bool
    let isHighlighted: Bool
    let isDelegateVoted: Bool
    let publicUserContext: ProposalListItemViewPublicUserContext
    let onDaoTap: (() -> Void)?

    @Environment(\.isPresented) private var _isPresented

    init(proposal: Proposal,
         isSelected: Bool = false,
         isRead: Bool = false,
         isPresented: Bool = false,
         isHighlighted: Bool = false,
         isDelegateVoted: Bool = false,
         publicUserContext: ProposalListItemViewPublicUserContext = .publicUser,
         onDaoTap: (() -> Void)? = nil) {
        self.proposal = proposal
        self.isSelected = isSelected
        self.isRead = isRead
        self.isPresented = isPresented
        self.isHighlighted = isHighlighted
        self.isDelegateVoted = isDelegateVoted
        self.publicUserContext = publicUserContext
        self.onDaoTap = onDaoTap
    }

    private var backgroundColor: Color {
        if isSelected {
            return .secondaryContainer
        }

        if UIDevice.current.userInterfaceIdiom != .phone {
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
                _ProposalListItemHeaderView(proposal: proposal, isDelegateVoted: isDelegateVoted)
                _ProposalListItemBodyView(proposal: proposal, publicUserContext: publicUserContext, onDaoTap: onDaoTap)
                _VoteFooterView(proposal: proposal)
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

struct _ProposalListItemHeaderView: View {
    let proposal: Proposal
    let isDelegateVoted: Bool
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    private var voted: Bool {
        proposal.userVote != nil
    }

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: proposal.author) {
                    activeSheetManager.activeSheet = .publicProfileById(proposal.author.address.value)
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
                } else if isDelegateVoted {
                    BubbleView(
                        image: Image(systemName: "checkmark"),
                        text: nil,
                        textColor: .onSecondaryContainer,
                        backgroundColor: .tertiaryContainer)
                }
                
                ProposalStatusView(state: proposal.state)
            }
        }
    }
}

struct _ProposalListItemBodyView: View {
    let proposal: Proposal
    let publicUserContext: ProposalListItemViewPublicUserContext
    let onDaoTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(proposal.title)
                    .foregroundStyle(Color.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)
                Spacer()
                RoundPictureView(image: proposal.dao.avatar(size: .m), imageSize: Avatar.Size.m.daoImageSize)
                    .allowsHitTesting(onDaoTap == nil ? false : true)
                    .onTapGesture {
                        onDaoTap?()
                    }
            }
            .frame(height: 48)
            .padding(.bottom, 4)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(proposal.votingEnd.isInPast ? "Vote finished " : "Vote finishes ")
                        .lineLimit(1)
                    DateView(date: proposal.votingEnd,
                             style: .numeric,
                             font: .footnoteRegular,
                             color: proposal.state == .active ? .primaryDim : .textWhite40)
                }
                .foregroundStyle(proposal.state == .active ? Color.primaryDim : .textWhite40)

                if let publicUserChoice = Utils.publicUserChoice(from: proposal) {
                    // public user voted
                    let choiceStr = Utils.choiseAsStr(proposal: proposal, choice: publicUserChoice)
                    switch publicUserContext {
                    case .publicUser:
                        Text("Delegate choice: \(choiceStr)")
                            .lineLimit(1)
                            .foregroundStyle(proposal.state == .active ? Color.delegateText : .textWhite40)
                    case .delegate:
                        Text("User choice: \(choiceStr)")
                            .lineLimit(1)
                            .foregroundStyle(proposal.state == .active ? Color.primaryDim : .textWhite40)
                    }
                }

                if let userChoice = Utils.userChoice(from: proposal) {
                    // user voted
                    let choiceStr = Utils.choiseAsStr(proposal: proposal, choice: userChoice)
                    Text("Your choice: \(choiceStr)")
                        .lineLimit(1)
                        .foregroundStyle(proposal.state == .active ? Color.primaryDim : .textWhite40)
                }
            }
            .font(.footnoteRegular)

            Spacer() // In a two-column design stratch to a height of a neighbour
        }
    }
}

fileprivate struct _VoteFooterView: View {
    let proposal: Proposal

    var votesHighlighted: Bool {
        proposal.state == .active
    }

    var quorumHighlighted: Bool {
        proposal.state == .active || proposal.quorum >= 100
    }

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                Text(Utils.formattedNumber(Double(proposal.votes)))
            }
            .font(.footnoteRegular)
            .foregroundStyle(votesHighlighted ? Color.textWhite : .textWhite40)

            if proposal.quorum > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "flag.checkered")
                    Text(Utils.numberWithPercent(from: proposal.quorum))
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
