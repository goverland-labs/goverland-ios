//
//  DaoDelegateInsightsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.09.24.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoDelegateInsightsView: View {
    let delegate: Delegate

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    DelegatedVpView(delegate: delegate)
                    DelegatedVpPercentView(delegate: delegate)
                }
                .padding(10)
            }
            .onAppear() {
                Tracker.track(.screenDelegateProfileInfo)
            }
        }
        .scrollIndicators(.hidden)
    }
}

fileprivate struct DelegatedVpView: View {
    let delegate: Delegate

    var description: String {
        let delegators = Utils.decimalNumber(from: delegate.delegators)
        let vp = Utils.formattedNumber(delegate.votingPower.power)
        let symbol = delegate.votingPower.symbol
        return "\(delegators) delegators have collectively delegated a total of \(vp) \(symbol)"
    }

    var body: some View {
        BrickView(header: "Delegated VP",
                  description: description,
                  data: Utils.formattedNumber(delegate.votingPower.power),
                  metadata: "\(delegate.delegators) delegators",
                  isLoading: false,
                  failedToLoadInitialData: false) { /* do nothing */ }
    }
}

fileprivate struct DelegatedVpPercentView: View {
    let delegate: Delegate

    var description: String {
        let percent = Utils.numberWithPercent(from: delegate.percentVotingPower)
        return "This delegate represents \(percent) of the total delegated voting power"
    }

    var body: some View {
        BrickView(header: "% of Delegated VP",
                  description: description,
                  data: Utils.numberWithPercent(from: delegate.percentVotingPower),
                  metadata: "", // TODO: add % of delegates
                  isLoading: false,
                  failedToLoadInitialData: false) { /* do nothing */ }
    }
}
