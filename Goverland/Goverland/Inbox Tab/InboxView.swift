//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

enum InboxFilter: Int, FilterOptions {
    case all = 0
    case vote
    case treasury

    var localizedName: String {
        switch self {
        case .all:
            return "All"
        case .vote:
            return "Vote"
        case .treasury:
            return "Treasury"
        }
    }
}

struct InboxView: View {
    @State private var filter: InboxFilter = .all
    @StateObject private var data = InboxDataSource()
    
    var body: some View {
        NavigationStack {
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
                    List(0..<data.events.count, id: \.self) { index in
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
                            ZStack {
                                NavigationLink(destination: SnapshotProposalView(proposal: proposal)) {}.opacity(0)
                                ProposalListItemView(proposal: proposal)
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button {
                                            data.archive(proposal: proposal)
                                        } label: {
                                            Label("Archive", systemImage: "trash")
                                        }
                                        .tint(.clear)
                                    }
                            }
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
            .onAppear() {
                data.refresh(withFilter: .all)
                Tracker.track(.screenInbox)
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
            .toolbarBackground(Color.surfaceBright, for: .navigationBar)
        }
    }
}
