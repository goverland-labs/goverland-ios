//
//  DaoInfoScreenView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI

struct DaoInfoScreenView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let event: ActivityEvent
    
    var body: some View {
        VStack {
            DaoInfoScreenHeaderView(event: event)
                .padding(.horizontal)
            DaoInfoScreenControlsView()
            Spacer()
        }
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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                FollowBellButtonView()
                NavigationLink(destination: EllipsisMenuView()) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

fileprivate struct FollowBellButtonView: View {
    
    @State private var didBellTap: Bool = false
    
    var body: some View {
        Button {
            didBellTap.toggle()
        } label: {
            Image(systemName: didBellTap ? "bell.fill" : "bell")
                .foregroundColor(.blue)
        }
    }
}

fileprivate struct EllipsisMenuView: View {
    var body: some View {
        Text("Ellipsis Menu View")
    }
}


struct DaoInfoScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoScreenView(event: ActivityEvent(
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
