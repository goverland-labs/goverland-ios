//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalListItemView: View {
    let proposal: Proposal
    let isRead: Bool
    let isSelected: Bool

    @Environment(\.presentationMode) private var presentationMode

    private var backgroundColor: Color {
        if isSelected {
            return .textWhite20
        }
        // if in a popover or on iPads, make it lighter
        if presentationMode.wrappedValue.isPresented || UIDevice.current.userInterfaceIdiom == .pad {
            return .containerBright
        }
        return .container
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
            
            VStack(spacing: 15) {
                ProposalListItemHeaderView(proposal: proposal, isRead: isRead)
                ProposalListItemBodyView(proposal: proposal)
                ProposalListItemFooterView(proposal: proposal)
            }
            .padding(.horizontal, 12)
        }
    }
}

fileprivate struct ProposalListItemHeaderView: View {
    let proposal: Proposal
    let isRead: Bool

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
                if !isRead {
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
            .frame(width: 4, height: 4)
    }
}

fileprivate struct ProposalListItemBodyView: View {
    let proposal: Proposal

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(proposal.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)

                // TODO: implement
                Text("Finishes in 3 days")
                    .foregroundColor(proposal.state == .active ? .primaryDim : .textWhite40)
                    .font(.footnoteRegular)
                    .lineLimit(1)

                // TODO: fix
                //                if let warning = data.content.warningSubtitle {
                //                    Text(warning)
                //                        .foregroundColor(.textWhite40)
                //                        .font(.footnoteRegular)
                //                        .lineLimit(1)
                //                } else {
                //                    Text("")
                //                }
            }

            Spacer()

            RoundPictureView(image: proposal.dao.avatar, imageSize: 46)
        }
    }
}

fileprivate struct ProposalListItemFooterView: View {
    let proposal: Proposal

    var body: some View {
        HStack(spacing: 20) {
            VoteFooterView(votes: proposal.votes, quorum: proposal.quorum)
            Spacer()
            InboxListItemFooterMenu()
        }
    }
}

fileprivate struct VoteFooterView: View {
    let votes: Int
    let quorum: Int

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                    .font(.footnoteRegular)

                Text(String(votes))
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }

            HStack(spacing: 5) {
                Image(systemName: "flag.checkered")
                    .foregroundColor(.white)
                    .font(.footnoteRegular)

                Text(String(quorum))
                    .fontWeight(.medium)
                    .font(.footnoteRegular)
            }
        }
    }
}

fileprivate struct InboxListItemFooterMenu: View {
    var body: some View {
        HStack(spacing: 15) {
            Menu {
                Button("Share", action: performShare)
                Button("Cancel", action: performCancel)
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.textWhite40)
                    .fontWeight(.bold)
                    .frame(height: 20)
            }
        }
    }

    private func performShare() {}

    private func performCancel() {}
}


struct ShimmerProposalListItemView: View {
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

                HStack {
                    ShimmerView()
                        .cornerRadius(20)
                        .frame(width: 250)
                    Spacer()
                }
                .frame(height: 20)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .frame(height: 160)
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView(proposal: .aaveTest, isRead: false, isSelected: false)
    }
}
