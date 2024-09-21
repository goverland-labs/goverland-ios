//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct InboxView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var data = InboxDataSource.shared

    @EnvironmentObject private var pathManager: NavigationPathManager
    @EnvironmentObject private var activeSheetManager: ActiveSheetManager

    @State private var showReminderErrorAlert = false
    @State private var showReminderSelection = false
    @State private var proposalForReminder: Proposal?

    var events: [InboxEvent] {
        data.events ?? []
    }

    var body: some View {
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
                        if let proposal = event.eventData! as? Proposal, event.visible {
                            let isRead = event.readAt != nil
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: false,
                                                 isRead: isRead,
                                                 onDaoTap: {
                                activeSheetManager.activeSheet = .daoInfoById(proposal.dao.id.uuidString)
                                Tracker.track(.inboxEventOpenDao)
                            })
                            .environmentObject(activeSheetManager)
                            // TODO: submit bug to Apple: onLongPressGesture overrides list selection
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    Haptic.medium()
                                    data.archive(eventID: event.id)
                                    Tracker.track(.inboxEventArchive)
                                } label: {
                                    Label("Archive", systemImage: "trash.fill")
                                }
                                .tint(.clear)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    Haptic.medium()
                                    if isRead {
                                        Tracker.track(.inboxEventMarkUnread)
                                        data.markUnread(eventID: event.id)
                                    } else {
                                        Tracker.track(.inboxEventMarkRead)
                                        data.markRead(eventID: event.id)
                                    }
                                } label: {
                                    if isRead {
                                        Label("Mark as unread", systemImage: "envelope.fill")
                                    } else {
                                        Label("Mark as read", systemImage: "envelope.open.fill")
                                    }
                                }
                                .tint(.clear)

                                Button {
                                    Tracker.track(.inboxEventAddReminder)
                                    RemindersManager.shared.requestAccess { granted in
                                        if granted {
                                            proposalForReminder = proposal // will show a popover
                                        } else {
                                            showReminderErrorAlert = true
                                        }
                                    }
                                } label: {
                                    Label("Remind to vote", systemImage: "bell.fill")
                                }
                                .tint(.clear)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
                        } else {
                            // event is not visible or not recognized
                            EmptyView()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }

            ToolbarTitle("Notifications")

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

                    Button {
                        TabManager.shared.selectedTab = .profile
                        TabManager.shared.profilePath = [.settings, .inboxNofitications]
                    } label: {
                        Label("Inbox Settings", systemImage: "gearshape.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.textWhite)
                        .fontWeight(.bold)
                        .frame(height: 20)
                }
            }
        }
        .onChange(of: data.selectedEventIndex) { _, _ in
            if let index = data.selectedEventIndex, events.count > index,
               let proposal = events[index].eventData as? Proposal
            {
                pathManager.path.append(proposal)
                let event = events[index]
                Tracker.track(.inboxEventOpen)
                if event.readAt == nil {
                    data.markRead(eventID: event.id)
                }
                data.selectedEventIndex = nil
            }
        }
        .navigationDestination(for: Proposal.self) { proposal in
            SnapshotProposalView(proposal: proposal)
                .environmentObject(activeSheetManager)
        }
        .onAppear() {
            if data.events?.isEmpty ?? true {
                data.refresh()
            }
            Tracker.track(.screenInbox)
        }
        .alert(isPresented: $showReminderErrorAlert) {
            RemindersManager.accessRequiredAlert()
        }
        .onChange(of: proposalForReminder) { oldValue, newValue in
            guard newValue != nil else { return }
            showReminderSelection = true
        }
        .sheet(isPresented: $showReminderSelection) {
            ProposalReminderSelectionView(proposal: proposalForReminder!)
                .presentationDetents([.height(600)])
                .onDisappear {
                    proposalForReminder = nil // to allow repeatitive selection
                }
        }
    }
}
