//
//  InboxView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.12.22.
//

import SwiftUI

struct InboxView: View {
    @State private var filter: FilterType = .all
    @StateObject private var data = InboxDataService()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                InboxFilterMenuView(filter: $filter, data: data)
                    .padding(10)
                    .background(Color.surfaceBright)

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
                                    .padding(.top, 10)
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
            .onAppear() { Tracker.track(.inboxView) }
            .background(Color.surface)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
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
    
    struct InboxView_Previews: PreviewProvider {
        static var previews: some View {
            InboxView()
        }
    }
}
