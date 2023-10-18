//
//  DaoInfoEventsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.07.23.
//

import SwiftUI

struct DaoInfoEventsView: View {
    @StateObject private var data: DaoInfoEventsDataSource

    @State private var selectedEventIndex: Int?
    @State private var path = NavigationPath()

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
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
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
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12))
                            .listRowBackground(Color.clear)
                        } else {
                            let proposal = event.eventData! as! Proposal
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: false,
                                                 isRead: false,
                                                 displayUnreadIndicator: false) {
                                ProposalSharingMenu(link: proposal.link)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                            .listRowBackground(Color.clear)
                        }
                    }                    
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onChange(of: selectedEventIndex) { _ in
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
