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
                                                 isSelected: selectedEventIndex == index,
                                                 isRead: false,
                                                 displayReadIndicator: false)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                path.append(proposal)
                            }
                        }
                    }
                    .refreshable {
                        data.refresh()
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal, allowShowingDaoInfo: false, navigationTitle: "")
            }
        }
        .onAppear() {
            data.refresh()
            // TODO: proper tracking
            //Tracker.track(.screenInbox)
        }
    }
}

struct DaoInfoEventsView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoEventsView(dao: .aave)
    }
}
