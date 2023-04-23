//
//  ProposalListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2022-12-28.
//

import SwiftUI

struct ProposalListItemView: View {
    @StateObject private var data = InboxDataService()

    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            if index == data.events.count - 1 && data.hasNextPageURL() {
                EmptyView()
                    .redacted(reason: .placeholder)
                    .onAppear {
                        data.getEvents(fromStart: false)
                    }
            } else {
                ZStack {
                    NavigationLink(destination: InboxItemDetailView(event: data.events[index])) {}.opacity(0)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.container)
                        VStack(spacing: 15) {
                            ProposalListItemHeaderView(user: data.events[index].user, date: data.events[index].date, status: data.events[index].status)
                            ProposalListItemBodyView(content: data.events[index].content, daoImage: data.events[index].daoImage)
                            ProposalListItemFooterView(meta: data.events[index].meta)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, -5)
                .padding(.top, 10)
            }
        }
        .refreshable {
            data.getEvents(fromStart: true)
        }
    }
}

struct InboxListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalListItemView()
    }
}
