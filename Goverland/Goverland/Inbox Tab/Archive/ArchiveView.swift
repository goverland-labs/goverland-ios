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
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.top, 4)
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
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12))
                            .listRowBackground(Color.clear)
                        } else {
                            let proposal = archive.eventData! as! Proposal
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: false,
                                                 isRead: archive.readAt != nil,
                                                 displayUnreadIndicator: archive.readAt == nil) {
                                ProposalSharingMenu(link: proposal.link)
                            }
                            .swipeActions {
                                Button {
                                    data.unarchive(eventID: archive.id)
                                    Tracker.track(.archiveEventUnarchive)
                                } label: {
                                    Label("Unarchive", systemImage: "envelope")
                                }
                                .tint(.clear)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Archive")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
            .onChange(of: selectedEventIndex) { _ in
                if let index = selectedEventIndex, archives.count > index,
                   let proposal = archives[index].eventData as? Proposal {
                    path.append(proposal)
                    Tracker.track(.archiveEventOpen)
                    if archives[index].readAt == nil {
                        data.markRead(eventID: archives[index].id)
                        Tracker.track(.archiveEventMarkRead)
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
        .accentColor(.textWhite)
        .overlay {
            ToastView()
        }
        .onAppear() {
            data.refresh()
            Tracker.track(.screenArchive)
        }
    }
}
