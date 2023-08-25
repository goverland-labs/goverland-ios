//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalSharingMenu: View {
    let link: String

    var body: some View {
        if let url = Utils.urlFromString(link) {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                UIApplication.shared.open(url)
            } label: {
                // for now we handle only Snapshot proposals
                Label("Open on Snapshot", systemImage: "arrow.up.right")
            }
        } else {
            ShareLink(item: link) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}

struct ProposalListItemView<Content: View>: View {
    let proposal: Proposal
    let isSelected: Bool
    let isRead: Bool
    let displayUnreadIndicator: Bool
    let isCondensedDisplay: Bool
    let onDaoTap: (() -> Void)?
    let menuContent: Content

    @Environment(\.presentationMode) private var presentationMode

    init(proposal: Proposal,
         isSelected: Bool,
         isRead: Bool,
         displayUnreadIndicator: Bool,
         isCondensedDisplay: Bool,
         onDaoTap: (() -> Void)? = nil,
         @ViewBuilder menuContent: () -> Content) {
        self.proposal = proposal
        self.isSelected = isSelected
        self.isRead = isRead
        self.displayUnreadIndicator = displayUnreadIndicator
        self.isCondensedDisplay = isCondensedDisplay
        self.onDaoTap = onDaoTap
        self.menuContent = menuContent()
    }

    private var backgroundColor: Color {
        if isSelected {
            return .secondaryContainer
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            return .containerBright
        }

        if presentationMode.wrappedValue.isPresented {
            return .containerBright
        }

        return .container
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)

            VStack(spacing: 15) {
                ProposalListItemHeaderView(proposal: proposal, displayReadIndicator: displayUnreadIndicator)
                ProposalListItemBodyView(proposal: proposal, isDescription: !isCondensedDisplay, onDaoTap: onDaoTap)
                if !isCondensedDisplay {
                    ProposalListItemFooterView(proposal: proposal) {
                        menuContent
                    }
                }
            }
            .padding(.horizontal, 12)

            if isRead && !isSelected {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.containerDim.opacity(0.6))
                    .allowsHitTesting(false)
            }
        }
    }
}

fileprivate struct ProposalListItemHeaderView: View {
    let proposal: Proposal
    let displayReadIndicator: Bool

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: proposal.author)
                DateView(date: proposal.created,
                         style: .named,
                         font: .footnoteRegular,
                         color: .textWhite40)
            }

            Spacer()

            HStack(spacing: 6) {
                if displayReadIndicator {
                    ReadIndicatiorView()
                }
                ProposalStatusView(state: proposal.state)
            }
        }
    }
}

fileprivate struct ReadIndicatiorView: View {
    var body: some View {
        Circle()
            .fill(Color.primary)
            .frame(width: 5, height: 5)
    }
}

fileprivate struct ProposalListItemBodyView: View {
    let proposal: Proposal
    let isDescription: Bool
    let onDaoTap: (() -> Void)?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(proposal.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)

                if isDescription {
                    HStack(spacing: 0) {
                        Text(proposal.votingEnd.isInPast ? "Vote finished " : "Vote finishes ")
                            .foregroundColor(proposal.state == .active ? .primaryDim : .textWhite40)
                            .font(.footnoteRegular)
                            .lineLimit(1)

                        DateView(date: proposal.votingEnd,
                                 style: .numeric,
                                 font: .footnoteRegular,
                                 color: proposal.state == .active ? .primaryDim : .textWhite40)
                    }
                }
            }

            Spacer()

            RoundPictureView(image: proposal.dao.avatar, imageSize: 46)
                .onTapGesture {
                    onDaoTap?()
                }
        }
    }
}

fileprivate struct ProposalListItemFooterView<Content: View>: View {
    let proposal: Proposal
    let menuContent: Content

    init(proposal: Proposal, @ViewBuilder menuContent: () -> Content) {
        self.proposal = proposal
        self.menuContent = menuContent()
    }

    var body: some View {
        HStack(spacing: 20) {
            VoteFooterView(votes: proposal.votes,
                           votesHighlighted: proposal.state == .active,
                           quorum: proposal.quorum,
                           quorumHighlighted: proposal.quorum >= 100)
            Spacer()

            HStack(spacing: 15) {
                Menu {
                    menuContent
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.textWhite40)
                        .fontWeight(.bold)
                        .frame(width: 40, height: 20)
                }
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

                Text(String(votes))
                    .fontWeight(.medium)
            }
            .font(.footnoteRegular)
            .foregroundColor(votesHighlighted ? .textWhite : .textWhite40)

            if quorum > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "flag.checkered")

                    Text(String(quorum))
                        .fontWeight(.medium)
                }
                .font(.footnoteRegular)
                .foregroundColor(quorumHighlighted ? .textWhite : .textWhite40)
            }
        }
    }
}

struct ShimmerProposalListItemView: View {
    let isCondensed: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)

            VStack(spacing: 15) {
                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 100)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 80)
                }
                .frame(height: 20)

                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 250)
                    Spacer()
                    ShimmerView()
                        .cornerRadius(25)
                        .frame(width: 50, height: 50)
                }
                .frame(height: 50)

                if !isCondensed {
                    HStack {
                        ShimmerView()
                            .cornerRadius(20)
                            .frame(width: 250)
                        Spacer()
                    }
                    .frame(height: 20)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .frame(height: isCondensed ? 110 : 160)
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView(proposal: .aaveTest,
                             isSelected: false,
                             isRead: false,
                             displayUnreadIndicator: true,
                             isCondensedDisplay: false) {}
    }
}
