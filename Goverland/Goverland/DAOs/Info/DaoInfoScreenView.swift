//
//  DaoInfoScreenView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI
//
//struct DaoInfoScreenView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    let event: InboxEvent
//    
//    var body: some View {
//        VStack {
//            DaoInfoScreenHeaderView(event: event)
//                .padding(.horizontal)
//            DaoInfoScreenControlsView()
//            Spacer()
//        }
//        .navigationTitle("Uniswap DAO")
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    self.presentationMode.wrappedValue.dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//            }
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                FollowBellButtonView()
//                NavigationLink(destination: EllipsisMenuView()) {
//                    Image(systemName: "ellipsis")
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .onAppear() { Tracker.track(.daoInfoScreenView) }
//    }
//}
//
//fileprivate struct FollowBellButtonView: View {
//    
//    @State private var didBellTap: Bool = false
//    
//    var body: some View {
//        Button {
//            didBellTap.toggle()
//        } label: {
//            Image(systemName: didBellTap ? "bell.fill" : "bell")
//                .foregroundColor(.blue)
//        }
//    }
//}
//
//fileprivate struct EllipsisMenuView: View {
//    var body: some View {
//        Text("Ellipsis Menu View")
//    }
//}
//
//
//struct DaoInfoScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        DaoInfoScreenView(event: InboxEvent.vote1)
//    }
//}
