//
//  ProposalStatusView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 18.04.23.
//

import SwiftUI

struct ProposalStatusView: View {
    var state: Proposal.State

    var body: some View {
        switch state {
        case .active:
            BubbleView(
                image: Image(systemName: "bolt.fill"),
                text: Text(state.localizedName),
                textColor: .onPrimary,
                backgroundColor: .primary)

        case .executed:
            BubbleView(
                image: Image(systemName: "checkmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .success)

        case .failed:
            BubbleView(
                image: Image(systemName: "bolt.slash.fill"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .fail)

        case .queued:
            BubbleView(
                image: Image(systemName: "clock"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .warning)

        case .succeeded:
            BubbleView(
                image: Image(systemName: "checkmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .success)

        case .defeated, .closed:
            BubbleView(
                image: Image(systemName: "xmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .danger)
        case .pending: // TODO: new status! we did not have it in design but we have it in backedn MOCS
            BubbleView(
                image: Image(systemName: "xmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .danger)
        }
    }
}

fileprivate struct BubbleView: View {
    var image: Image?
    var text: Text
    var textColor: Color
    var backgroundColor: Color

    var body: some View {
        HStack(spacing: 3) {
            image
                .font(.system(size: 9))
                .foregroundColor(textColor)
            text
                .font(.caption2Semibold)
                .foregroundColor(textColor)
                .lineLimit(1)
        }
        .padding([.leading, .trailing], 9)
        .padding([.top, .bottom], 5)
        .background(Capsule().fill(backgroundColor))
    }
}
