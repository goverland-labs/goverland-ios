//
//  SearchProposalView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-07.
//

import SwiftUI

struct SearchProposalView: View {
    @StateObject var dataSource: ProposalDataSource
    var body: some View {
        VStack(spacing: 0) {
            if dataSource.isLoading && dataSource.proposalsList.count == 0 {
                ScrollView {
                    ForEach(0..<5) { _ in
                        ShimmerProposalListItemView()
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 4)
            } else {
                // TODO: pagination
                // TODO: shimmer when loading more data
                // TODO: open proposal detail (info)
                ScrollView {
                    ForEach(dataSource.proposalsList.indices, id: \.self) { i in
                        ProposalListItemView(proposal: dataSource.proposalsList[i])
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onAppear {
            Tracker.track(.searchProposalView)
            dataSource.refresh()
        }
    }
}

struct SearchProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProposalView(dataSource: ProposalDataSource())
    }
}
