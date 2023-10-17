//
//  DashboardHotProposalsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.10.23.
//

import SwiftUI

struct DashboardHotProposalsView: View {
    @StateObject var dataSource = TopProposalsDataSource.dashboard
    @Binding var path: NavigationPath
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    @State private var selectedProposalIndex: Int?

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                // TODO: reload icon
                EmptyView()
            } else if dataSource.isLoading && dataSource.proposals.count == 0 {
                ScrollView {
                    ForEach(0..<3) { _ in
                        ShimmerProposalListItemCondensedView()
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 4)
            } else {
                List(0..<min(3, dataSource.proposals.count), id: \.self, selection: $selectedProposalIndex) { index in
                    let proposal = dataSource.proposals[index]
                    ProposalListItemCondensedView(proposal: proposal) {
                        activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                        // TODO: proper tracking
//                        Tracker.track(.searchPrpOpenDaoFromCard)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                    .listRowBackground(Color.clear)
                }
            }
        }
        .onChange(of: selectedProposalIndex) { _ in
            if let index = selectedProposalIndex, dataSource.proposals.count > index {
                path.append(dataSource.proposals[index])
                // TODO: proper tracking
//                Tracker.track(.searchPrpOpenFromCard)
            }
        }
        .onAppear {
            selectedProposalIndex = nil
            if dataSource.proposals.isEmpty {
                dataSource.refresh()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
