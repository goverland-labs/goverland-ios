//
//  DaoInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI


struct DaoInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var dataSource: DaoInfoDataSource

    init(daoID: UUID) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(daoID: daoID))
    }
    
    var body: some View {
        VStack {
            DaoInfoScreenHeaderView(dao: dataSource.dao)
                .padding(.horizontal)
            DaoInfoScreenControlsView(dao: dataSource.dao)
            Spacer()
        }
        .navigationTitle(dataSource.dao.name)
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
        .onAppear() { Tracker.track(.daoInfoScreenView)
            dataSource.loadInitialData()
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


struct DaoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoView(daoID: UUID())
    }
}
