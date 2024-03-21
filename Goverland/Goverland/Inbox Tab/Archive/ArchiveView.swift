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
                        ForEach(0..<5) { _ in
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
                                                 isRead: isRead) {
                                ProposalSharingMenu(link: proposal.link, isRead: isRead) {
                                    if isRead {
                                        Tracker.track(.archiveEventMarkUnread)
                                        data.markUnread(eventID: archive.id)
                                    } else {
                                        Tracker.track(.archiveEventMarkRead)
                                        data.markRead(eventID: archive.id)
                                    }
                                }
                            }
                            .swipeActions {
                                Button {
                                    Haptic.medium()
                                    data.unarchive(eventID: archive.id)
                                    Tracker.track(.archiveEventUnarchive)
                                } label: {
                                    Label("Unarchive", systemImage: "envelope")
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
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: false,
                                     navigationTitle: proposal.dao.name)
            }
        }
        .tint(.textWhite)
        .overlay {
            ToastView()
        }
        .onAppear() {
            data.refresh()
            Tracker.track(.screenArchive)
        }
    }
}
