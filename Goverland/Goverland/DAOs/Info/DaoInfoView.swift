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

    // TODO: manually test this initializer. We don't need it yet, but it should work with the related code
    init(daoID: UUID) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(daoID: daoID))
    }

    init(dao: Dao) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(dao: dao))
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                // TODO: make shimmer view similar to DAO info header view once the design is ready
                ShimmerLoadingItemView()
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else {
                DaoInfoScreenHeaderView(dao: dataSource.dao!)
                    .padding(.horizontal)
                    .padding(.bottom)
                DaoInfoScreenControlsView(dao: dataSource.dao!)
                Spacer()
            }
        }
        .navigationTitle(dataSource.dao?.name ?? "")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                //FollowBellButtonView()
                NavigationLink(destination: EllipsisMenuView()) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                }
            }
        }
        .onAppear() { Tracker.track(.daoInfoScreenView) }
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
