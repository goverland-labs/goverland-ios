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
    @StateObject private var data = InboxDataService()
    
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
                        ForEach(0..<3) { _ in
                            // TODO: move and style inside
                            ShimmerLoadingItemView()
                                .cornerRadius(20)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .frame(height: 180)
                        }
                    }
                } else {
                    List(0..<data.events.count, id: \.self) { index in
                        let event = data.events[index]
                        if index == data.events.count - 1 && data.hasMore() {
                            ZStack {
                                ShimmerLoadingItemView()
                                    .cornerRadius(20)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, -5)
                                    .frame(height: 180)
                                    .onAppear {
                                        data.loadMore()
                                    }
                            }
                            .listRowBackground(Color.surface)
                            .listRowSeparator(.hidden)
                        } else {
                            let proposal = event.eventData! as! Proposal
                            ZStack {
                                NavigationLink(destination: SnapshotProposalView(proposal: proposal)) {}.opacity(0)
                                ProposalListItemView(proposal: proposal)
                                    .padding(.bottom, 10)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, -5)
                        }
                    }
                    .refreshable {
                        data.refresh(withFilter: filter)
                    }
                }
            }
            .onAppear() {
                data.refresh(withFilter: .all)
                Tracker.track(.inboxView)
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
