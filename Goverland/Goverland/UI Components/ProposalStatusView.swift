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
        case .active:
            BubbleView(
                image: Image(systemName: "bolt.fill"),
                text: Text(state.localizedName),
                textColor: .onPrimary,
                backgroundColor: .primary)
            
        case .defeated, .closed:
            BubbleView(
                image: Image(systemName: "xmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .danger)
            
        case .failed:
            BubbleView(
                image: Image(systemName: "bolt.slash.fill"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .fail)
            
        case .succeeded, .executed:
            BubbleView(
                image: Image(systemName: "checkmark"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .success)
            
        case .queued, .pending:
            BubbleView(
                image: Image(systemName: "clock"),
                text: Text(state.localizedName),
                textColor: .textWhite,
                backgroundColor: .warning)
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
