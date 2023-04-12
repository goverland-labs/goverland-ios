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
            VStack(spacing: 10) {
                InboxFilterMenuView(filter: $filter, data: data)
                    .padding(10)
                    .background(Color.goverlandInboxHeader)
                List(0..<data.events.count, id: \.self) { index in
                    if index == data.events.count - 1 && data.hasNextPageURL() {
                        InboxListItemView(event: data.events[index])
                            .redacted(reason: .placeholder)
                            .onAppear {
                                data.getEvents(withFilter: filter, fromStart: false)
                            }
                    } else {
                        ZStack {
                            NavigationLink(destination: InboxItemDetailView(event: data.events[index])) {}.opacity(0)
                            InboxListItemView(event: data.events[index])
                                .padding(.bottom, 10)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, -15)
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Inbox")
                            .font(.system(size: 20))
                            .bold()
                    }
                }
            }
            .toolbarBackground(Color.goverlandInboxHeader, for: .navigationBar)
            .refreshable {
                data.getEvents(withFilter: filter, fromStart: true)
            }
        }
        .onAppear() { Tracker.track(.inboxView) }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
