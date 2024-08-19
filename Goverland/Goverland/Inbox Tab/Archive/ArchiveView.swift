//
//  ArchiveView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

struct ArchiveView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var data = ArchiveDataSource()
    @StateObject private var activeSheetManager = ActiveSheetManager()
    @State private var selectedEventIndex: Int?
    @State private var path = NavigationPath()

    var archives: [InboxEvent] {
        data.events ?? []
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if data.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: data,
                                            message: "Sorry, we couldn’t load the archive")
                } else if data.events?.count == 0 {
                    // loading had finished, data.archives != nil
                    EmptyArchiveView {
                        dismiss()
                    }
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
                    List(0..<archives.count, id: \.self, selection: $selectedEventIndex) { index in
                        let archive = archives[index]
                        if index == archives.count - 1 && data.hasMore() {
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
                            let proposal = archive.eventData! as! Proposal
                            let isRead = archive.readAt != nil
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: false,
                                                 isRead: isRead,
                                                 onDaoTap: {
                                activeSheetManager.activeSheet = .daoInfo(proposal.dao)
                                Tracker.track(.archiveEventOpenDao)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    unarchive(eventId: archive.id)
                                } label: {
                                    Label("Unarchive", systemImage: "trash.slash.fill")
                                }
                                .tint(.clear)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    Haptic.medium()
                                    if isRead {
                                        Tracker.track(.archiveEventMarkUnread)
                                        data.markUnread(eventID: archive.id)
                                    } else {
                                        Tracker.track(.archiveEventMarkRead)
                                        data.markRead(eventID: archive.id)
                                    }
                                } label: {
                                    if isRead {
                                        Label("Mark as unread", systemImage: "envelope.fill")
                                    } else {
                                        Label("Mark as read", systemImage: "envelope.open.fill")
                                    }
                                }
                                .tint(.clear)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(Constants.listInsets)
                            .listRowBackground(Color.clear)
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

                ToolbarTitle("Archive")
            }
            .onChange(of: selectedEventIndex) { _, _ in
                if let index = selectedEventIndex, archives.count > index,
                   let proposal = archives[index].eventData as? Proposal {
                    path.append(proposal)
                    Tracker.track(.archiveEventOpen)
                    if archives[index].readAt == nil {
                        data.markRead(eventID: archives[index].id)
                    }
                    selectedEventIndex = nil
                }
            }
            .navigationDestination(for: Proposal.self) { proposal in
                SnapshotProposalView(proposal: proposal)
                    .environmentObject(activeSheetManager)
            }
        }
        .tint(.textWhite)
        .overlay {
            // we need it to espace crashes inside ToastView
            ToastView()
                .environmentObject(activeSheetManager)
        }
        .onAppear() {
            data.refresh()
            Tracker.track(.screenArchive)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            switch item {
            case .daoInfo(let dao):
                PopoverNavigationViewWithToast {
                    DaoInfoView(dao: dao)
                }

            case .publicProfileById(let profileId):
                PopoverNavigationViewWithToast {
                    PublicUserProfileView(profileId: profileId)
                }

            case .proposalVoters(let proposal):
                PopoverNavigationViewWithToast {
                    SnapshotAllVotesView(proposal: proposal)
                }

            default:
                EmptyView()
            }
        }
    }

    private func unarchive(eventId: UUID) {
        Haptic.medium()
        data.unarchive(eventID: eventId)
        Tracker.track(.archiveEventUnarchive)
    }
}
