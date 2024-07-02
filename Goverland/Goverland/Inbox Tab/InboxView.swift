//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct InboxView: View {
    @StateObject private var data = InboxDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var shouldRefreshAfterVote = false

    var events: [InboxEvent] {
        data.events ?? []
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if data.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: data,
                                            message: "Sorry, we couldn’t load the inbox")
                } else if data.events?.count == 0 {
                    // loading had finished, data.events != nil
                    EmptyInboxView()
                } else if data.isLoading && data.events == nil {
                    // loading in progress
                    ScrollView {
                        ForEach(0..<7) { _ in
                            ShimmerProposalListItemView()
                                .padding(.horizontal, Constants.horizontalPadding)
                        }
                    }
                    .padding(.top, Constants.horizontalPadding / 2)
                } else {
                    List(0..<events.count, id: \.self, selection: $data.selectedEventIndex) { index in
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
                            // For now we recognise only proposals
                            let proposal = event.eventData! as! Proposal
                            let isRead = event.readAt != nil
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: data.selectedEventIndex == index,
                                                 isRead: isRead,
                                                 onDaoTap: {
                                activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                                Tracker.track(.inboxEventOpenDao)
                            }) {
                                ProposalSharingMenu(
                                    link: proposal.link,
                                    isRead: isRead,
                                    markCompletion: {
                                        Haptic.medium()
                                        if isRead {
                                            Tracker.track(.inboxEventMarkUnread)
                                            data.markUnread(eventID: event.id)
                                        } else {
                                            Tracker.track(.inboxEventMarkRead)
                                            data.markRead(eventID: event.id)
                                        }
                                    },
                                    isArchived: false,
                                    archivationCompletion: {
                                        archive(eventId: event.id)
                                    }
                                )
                            }
                            .swipeActions {
                                Button {
                                    archive(eventId: event.id)
                                } label: {
                                    Label("Archive", systemImage: "trash.fill")
                                }
                                .tint(.clear)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
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
                ToolbarTitle("Inbox")

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            activeSheetManager.activeSheet = .archive
                        } label: {
                            Label("See Archive", systemImage: "archivebox.fill")
                        }

                        Button {
                            data.markAllEventsRead() // also refreshes inbox
                        } label: {
                            Label("Mark all as read", systemImage: "envelope.open.fill")
                        }

                        Button {
                            TabManager.shared.selectedTab = .profile
                            TabManager.shared.profilePath = [.followedDaos]
                        } label: {
                            Label("My followed DAOs", systemImage: "d.circle.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }  detail: {
            if let index = data.selectedEventIndex, events.count > index,
               let proposal = events[index].eventData as? Proposal {
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: true)
            } else {
                EmptyView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .voteCasted)) { notification in
            shouldRefreshAfterVote = true
        }
        .onChange(of: data.selectedEventIndex) { _, _ in
            if let index = data.selectedEventIndex, events.count > index {
                let event = events[index]
                Tracker.track(.inboxEventOpen)
                if event.readAt == nil {
                    data.markRead(eventID: event.id)
                }
            }
            // refresh after a vote to enable auto-archiving
            if shouldRefreshAfterVote {
                data.refresh()
            }
        }
        .onAppear() {
            if data.events?.isEmpty ?? true {
                data.refresh()
                Tracker.track(.screenInbox)
            }
        }
    }

    private func archive(eventId: UUID) {
        Haptic.medium()
        data.archive(eventID: eventId)
        Tracker.track(.inboxEventArchive)
    }
}
