//
//  ArchiveSettingsView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject private var data = ArchiveDataSource()
    @State private var selectedEventIndex: Int?
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    var archives: [InboxEvent] {
        data.archives ?? []
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if data.failedToLoadInitialData {
                    RetryInitialLoadingView(dataSource: data)
                } else if data.archives?.count == 0 {
                    // loading had finished, data.archives != nil
                    EmptyInboxView()
                } else if data.isLoading && data.archives == nil {
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
                            // For now we recognise only proposals
                            let proposal = archive.eventData! as! Proposal
                            ProposalListItemView(proposal: proposal,
                                                 isSelected: selectedEventIndex == index,
                                                 isRead: archive.readAt != nil,
                                                 displayUnreadIndicator: archive.readAt == nil,
                                                 onDaoTap: {print("")})
                            {
                                ProposalSharingMenu(link: proposal.link)
                            }
                            .swipeActions(allowsFullSwipe: false) {
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
                        Text("Archive")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }
            }
        }  detail: {
            if let index = selectedEventIndex, archives.count > index,
               let proposal = archives[index].eventData as? Proposal {
                SnapshotProposalView(proposal: proposal,
                                     allowShowingDaoInfo: true,
                                     navigationTitle: proposal.dao.name)
            } else {
                EmptyView()
            }
        }
        .onAppear() {
            data.refresh()
            Tracker.track(.screenArchive)
        }
    }
}
