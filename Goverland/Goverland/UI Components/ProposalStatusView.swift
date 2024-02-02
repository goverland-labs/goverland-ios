//
//  ProposalStatusView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ProposalStatusView: View {
    var state: Proposal.State

    var body: some View {
        switch state {
        case .pending:
            BubbleView(
                image: Image(systemName: "clock"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .warning)

        case .active:
            BubbleView(
                image: Image(systemName: "bolt.fill"),
                text: Text(state.localizedName),
                textColor: .onPrimary,
                backgroundColor: .primary)

        case .failed:
            BubbleView(
                image: Image(systemName: "bolt.slash.fill"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .fail)

        case .succeeded:
            BubbleView(
                image: Image(systemName: "checkmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .success)

        case .defeated, .canceled:
            BubbleView(
                image: Image(systemName: "xmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .danger)
        }
    }
}
