//
//  ProposalListItemCondensedView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//

import SwiftUI

struct ProposalListItemCondensedView: View {
    let proposal: Proposal
    let onDaoTap: (() -> Void)?

    @Environment(\.presentationMode) private var presentationMode

    init(proposal: Proposal,
         onDaoTap: (() -> Void)? = nil) {
        self.proposal = proposal
        self.onDaoTap = onDaoTap
    }

    private var backgroundColor: Color {
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
                ProposalListItemCondensedHeaderView(proposal: proposal)
                ProposalListItemCondensedBodyView(proposal: proposal,
                                                  onDaoTap: onDaoTap)
                
            }
            .padding(.horizontal, 12)
        }
    }
}

fileprivate struct ProposalListItemCondensedHeaderView: View {
    let proposal: Proposal

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
            ProposalStatusView(state: proposal.state)
        }
    }
}

fileprivate struct ProposalListItemCondensedBodyView: View {
    let proposal: Proposal
    let onDaoTap: (() -> Void)?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(proposal.title)
                    .foregroundColor(.textWhite)
                    .font(.headlineSemibold)
                    .lineLimit(2)
            }

            Spacer()
            RoundPictureView(image: proposal.dao.avatar, imageSize: 46)
                .onTapGesture {
                    onDaoTap?()
                }
        }
    }
}

struct ShimmerProposalListItemCondensedView: View {
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
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .frame(height: 110)
    }
}

struct ProposalListItemCondensedView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemCondensedView(proposal: .aaveTest)
    }
}
