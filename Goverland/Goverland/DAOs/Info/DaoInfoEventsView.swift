//
//  DaoInfoEventsView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.07.23.
//

import SwiftUI

struct DaoInfoEventsView: View {
    @State private var filter: InboxFilter = .all
    @StateObject private var data: DaoInfoEventsDataSource

    @State private var selectedEventIndex: Int?
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    let dao: Dao

    init(dao: Dao) {
        let dataSource = DaoInfoEventsDataSource(daoID: dao.id)
        _data = StateObject(wrappedValue: dataSource)
        self.dao = dao
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack(spacing: 0) {
                // TODO: enable once backend is ready
                //                FilterButtonsView<InboxFilter>(filter: $filter) { newValue in
                //                    data.refresh(withFilter: newValue)
                //                }
                //                .padding(10)
                //                .background(Color.surfaceBright)
                if data.isLoading && data.events.count == 0 {
                    ScrollView {
                        ForEach(0..<5) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
                } else {
                    List(0..<data.events.count, id: \.self, selection: $selectedEventIndex) { index in
                        let event = data.events[index]
                        if index == data.events.count - 1 && data.hasMore() {
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
                                                 isRead: event.readAt != nil,
                                                 isSelected: selectedEventIndex == index)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                            .listRowBackground(Color.clear)
                        }
                    }
                    .refreshable {
                        data.refresh(withFilter: filter)
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }  detail: {
            if let index = selectedEventIndex, data.events.count > index,
               let proposal = data.events[index].eventData as? Proposal {
                SnapshotProposalView(proposal: proposal)
            } else {
                EmptyView()
            }
        }
        .toolbarBackground(Color.surfaceBright, for: .navigationBar)
        .onAppear() {
            data.refresh(withFilter: .all)
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
