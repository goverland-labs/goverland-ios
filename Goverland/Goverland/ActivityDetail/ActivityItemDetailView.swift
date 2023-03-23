//
//  ActivityItemDetailView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-18.
//

import SwiftUI

struct ActivityItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var event: ActivityEvent
    
    var body: some View {
        VStack(spacing: 0) {
            ActivityDetailDividerLineView()
                .padding(.bottom, 15)
            NavigationLink(destination: DaoInfoScreenView(event: event)) {
                ActivityDetailHeaderView(event: event)
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
            }
            ActivityDetailStatusRowView()
                .padding(.bottom, 25)
            ActivityDetailSummaryView(user: event.user)
                .padding(.bottom, 40)
            ActivityDetailForumView(event: event)
                .padding(.bottom, 30)
            ActivityDetailDividerLineView()
                .padding(.bottom, 30)
            ActivityTimelineView(user: event.user)
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
        .onAppear() { Tracker.track(.activityDetailView) }
    }
}

struct ActivityItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityItemDetailView(event: ActivityEvent(
            id: UUID(),
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: URL(string: ""),
                name: "safe1.sche.eth"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(title: "title", subtitle: "subtitle", warningSubtitle: "warningSubtitle"),
            daoImage: URL(string: ""),
            meta: ActivityEventsVoteMeta(voters: 1, quorum: "1", voted: true)))
    }
}
