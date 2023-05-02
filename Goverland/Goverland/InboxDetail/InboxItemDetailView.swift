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

    var data: VoteEventData {
        event.data as! VoteEventData
    }
    
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
            InboxDetailSummaryView(user: data.user)
                .padding(.bottom, 40)
            InboxDetailForumView(event: event)
                .padding(.bottom, 30)
            InboxDetailDividerLineView()
                .padding(.bottom, 30)
            InboxTimelineView(user: data.user)
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
        .onAppear() { Tracker.track(.stapshotProposalView) }
    }
}

struct InboxItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemDetailView(event: .vote1)
    }
}
