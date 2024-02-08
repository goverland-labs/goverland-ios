//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct InboxView: View {
    @Setting(\.authToken) private var authToken

    var body: some View {
        if authToken.isEmpty {
            NavigationView {
                SignInView(source: .inbox)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Inbox")
                                    .font(.title3Semibold)
                                    .foregroundColor(Color.textWhite)
                            }
                        }
                    }
            }
            .environment(\.horizontalSizeClass, .compact)
        } else {
            _InboxView()
        }
    }
}

fileprivate struct _InboxView: View {
    @StateObject private var data = InboxDataSource.shared
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var selectedEventIndex: Int?
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

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
                            // For now we recognise only proposals
                            let proposal = event.eventData! as! Proposal
                            let isRead = event.readAt != nil
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: selectedEventIndex == index,
                                                 isRead: isRead,
                                                 onDaoTap: {
                                activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                                Tracker.track(.inboxEventOpenDao)
                            }) {
                                ProposalSharingMenu(link: proposal.link, isRead: isRead) {
                                    if isRead {
                                        Tracker.track(.inboxEventMarkUnread)
                                        data.markUnread(eventID: event.id)
                                    } else {
                                        Tracker.track(.inboxEventMarkRead)
                                        data.markRead(eventID: event.id)
                                    }
                                }
                            }
                            .swipeActions {
                                Button {
                                    Haptic.medium()
                                    data.archive(eventID: event.id)
                                    Tracker.track(.inboxEventArchive)
                                } label: {
                                    Label("Archive", systemImage: "archivebox.fill")
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
                            .foregroundColor(Color.textWhite)
                    }
                }

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
                            .foregroundColor(.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }  detail: {
            if let index = selectedEventIndex, events.count > index,
               let proposal = events[index].eventData as? Proposal {
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: true,
                                     navigationTitle: proposal.dao.name)
            } else {
                EmptyView()
            }
        }
        .onChange(of: selectedEventIndex) { _, _ in
            if let index = selectedEventIndex, events.count > index {
                let event = events[index]
                Tracker.track(.inboxEventOpen)
                if event.readAt == nil {
                    data.markRead(eventID: event.id)
                }
            }
        }
        .onAppear() {
            if data.events?.isEmpty ?? true {
                data.refresh()
                Tracker.track(.screenInbox)
            }            
        }
    }
}
