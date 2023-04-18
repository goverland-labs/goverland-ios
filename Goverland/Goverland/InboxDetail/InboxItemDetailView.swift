//
//  InboxItemDetailView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct InboxItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var event: InboxEvent
    
    var body: some View {
        VStack(spacing: 0) {
            InboxDetailDividerLineView()
                .padding(.bottom, 15)
            NavigationLink(destination: DaoInfoScreenView(event: event)) {
                InboxDetailHeaderView(event: event)
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
            }
            InboxDetailStatusRowView()
                .padding(.bottom, 25)
            InboxDetailSummaryView(user: event.user)
                .padding(.bottom, 40)
            InboxDetailForumView(event: event)
                .padding(.bottom, 30)
            InboxDetailDividerLineView()
                .padding(.bottom, 30)
            InboxTimelineView(user: event.user)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .navigationTitle("Uniswap DAO")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onAppear() { Tracker.track(.inboxDetailView) }
    }
}

struct InboxItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemDetailView(event: InboxEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: InboxViewContent(title: "title", subtitle: "subtitle", warningSubtitle: "warningSubtitle"),
            daoImage: URL(string: ""),
            meta: InboxEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
