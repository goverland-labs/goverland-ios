//
//  DaoInfoEventsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct DaoInfoEventsView: View {
    @StateObject private var data: DaoInfoEventsDataSource

    @State private var selectedEventIndex: Int?
    @State private var path = NavigationPath()

    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    let dao: Dao

    init(dao: Dao) {
        let dataSource = DaoInfoEventsDataSource(daoID: dao.id)
        _data = StateObject(wrappedValue: dataSource)
        self.dao = dao
    }

    var events: [InboxEvent] {
        data.events ?? []
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if data.isLoading && data.events == nil {
                    // loading in progress
                    ScrollView {
                        ForEach(0..<5) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, Constants.horizontalPadding)
                        }
                    }
                    .padding(.top, Constants.horizontalPadding)
                } else {
                    List(0..<events.count, id: \.self, selection: $selectedEventIndex) { index in
                        let event = events[index]
                        if index == events.count - 1 && data.hasMore() {
                            ZStack {
                                if !data.failedToLoadMore {
                                    ShimmerProposalListItemView()
                                        .onAppear {
                                            data.loadMore()
                                        }
                                } else {
                                    RetryLoadMoreListItemView(dataSource: data)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
                        } else {
                            let proposal = event.eventData! as! Proposal
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: false,
                                                 isRead: false) {
                                ProposalSharingMenu(link: proposal.link, isRead: nil, markCompletion: nil)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .padding(.top, Constants.horizontalPadding / 2)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onChange(of: selectedEventIndex) { _, _ in
                if let index = selectedEventIndex, events.count > index,
                   let proposal = events[index].eventData as? Proposal {
                    path.append(proposal)
                }
                selectedEventIndex = nil
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: false,
                                     navigationTitle: "")
                .onAppear {
                    Tracker.track(.daoEventOpen)
                }
                // TODO: create Apple ticket with found bug
                .environmentObject(activeSheetManager)
            }
        }
        .onAppear() {
            if data.events?.isEmpty ?? true {
                data.refresh()
            }
            Tracker.track(.screenDaoFeed, parameters: ["dao_name": dao.name])
        }
    }
}
