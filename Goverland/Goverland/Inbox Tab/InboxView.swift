//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct InboxView: View {
    @StateObject private var data = InboxDataSource()
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager

    @State private var selectedEventIndex: Int?
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    var events: [InboxEvent] {
        data.events ?? []
    }
    
    var body: some View {
        Group {
            if data.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: data)                    
            } else if data.events?.count == 0 {
                // loading had finished, data.events != nil
                EmptyInboxView()
            } else {
                NavigationSplitView(columnVisibility: $columnVisibility) {
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
                                    // For now we recognise only proosals
                                    let proposal = event.eventData! as! Proposal
                                    ProposalListItemView(proposal: proposal,
                                                         isSelected: selectedEventIndex == index,
                                                         isRead: event.readAt != nil,
                                                         displayUnreadIndicator: event.readAt == nil,
                                                         onDaoTap: {
                                        activeSheetManger.activeSheet = .daoInfo(proposal.dao)
                                        Tracker.track(.inboxEventOpenDao)
                                    }) {
                                        ProposalSharingMenu(link: proposal.link)
                                    }
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button {
                                            data.archive(eventID: event.id)
                                            Tracker.track(.inboxEventArchive)
                                        } label: {
                                            Label("Archive", systemImage: "trash")
                                        }
                                        .tint(.clear)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                                    .listRowBackground(Color.clear)
                                }
                            }
                            .refreshable {
                                data.refresh()
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Inbox")
                                    .font(.title3Semibold)
                            }
                        }
                    }
                }  detail: {
                    if let index = selectedEventIndex, events.count > index,
                       let proposal = events[index].eventData as? Proposal {
                        SnapshotProposalView(proposal: proposal,
                                             allowShowingDaoInfo: true,
                                             navigationTitle: proposal.dao.name,
                                             timeline: events[index].timeline)
                    } else {
                        EmptyView()
                    }
                }
                .onChange(of: selectedEventIndex) { _ in
                    if let index = selectedEventIndex, events.count > index {
                        let event = events[index]
                        Tracker.track(.inboxEventOpen)
                        if event.readAt == nil {
                            Tracker.track(.inboxEventMarkRead)
                            data.markRead(eventID: event.id)
                        }
                    }
                }
                .onAppear() {
                    data.refresh()
                    // TODO: track only if screen is presented here
                    // and where emply. It is triggered on every DAO follow
                    Tracker.track(.screenInbox)
                }
            }
        }
    }
}
