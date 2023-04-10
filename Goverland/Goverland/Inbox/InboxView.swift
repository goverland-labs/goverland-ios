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
            VStack {
                InboxFilterMenuView(filter: $filter, data: data)
                List(0..<data.events.count, id: \.self) { index in
                    if index == data.events.count - 1 && data.hasNextPageURL() {
                        
                        InboxListItemView(event: data.events[index])
                            .redacted(reason: .placeholder)
                            .onAppear {
                                data.getEvents(withFilter: filter, fromStart: false)
                            }
                    } else {
                        InboxListItemView(event: data.events[index])
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                            .padding(.top, 10)
                            .listRowBackground(Color("lightGray-black"))
                            .overlay(NavigationLink("", destination: InboxItemDetailView(event: data.events[index])).opacity(0))
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(.horizontal, 10)
                .navigationBarBackButtonHidden()
                .refreshable {
                    data.getEvents(withFilter: filter, fromStart: true)
                }
            }
            .background(Color("lightGray-black"))
        }
        .onAppear() { Tracker.track(.inboxView) }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
