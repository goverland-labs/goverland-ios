//
//  ProposalListItemCondensedView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-08-29.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalListItemCondensedView: View {
    let proposal: Proposal
    let onDaoTap: (() -> Void)?

    @Environment(\.isPresented) private var isPresented

    init(proposal: Proposal,
         onDaoTap: (() -> Void)? = nil) {
        self.proposal = proposal
        self.onDaoTap = onDaoTap
    }

    private var backgroundColor: Color {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .containerBright
        }

        if isPresented {
            return .containerBright
        }

        return .container
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)

            VStack(spacing: 12) {
                ProposalListItemHeaderView(proposal: proposal)
                ProposalListItemBodyView(proposal: proposal, displayStatus: false, onDaoTap: onDaoTap)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.horizontalPadding)
        }
    }
}

struct ShimmerProposalListItemCondensedView: View {
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
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.horizontalPadding)
        }
        .frame(height: 104)
    }
}
