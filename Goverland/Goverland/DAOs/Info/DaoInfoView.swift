//
//  DaoInfoView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-07.
//

import SwiftUI

enum DaoInfoFilter: Int, FilterOptions {
    case activity = 0
    case about

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .about:
            return "About"
        }
    }
}

struct DaoInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var dataSource: DaoInfoDataSource
    @State private var filter: DaoInfoFilter = .activity

    var dao: Dao { dataSource.dao! }

    init(daoID: UUID) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(daoID: daoID))
    }

    init(dao: Dao) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(dao: dao))
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                // Unfortunately shimmer or reducted view here breaks preseantation in a popover view
                ProgressView()
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else {
                VStack {
                    DaoInfoScreenHeaderView(dao: dao)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    FilterButtonsView<DaoInfoFilter>(filter: $filter) { newValue in
                        switch newValue {
                        case .activity: dataSource.refresh()
                        case .about: break
                        }
                    }
                    .padding(.bottom, 4)
                    
                    switch filter {
                    case .activity: InboxView()
                    case .about: DaoInfoAboutDaoView(dao: dao)
                    }
                }
            }
        }
        .navigationTitle(dataSource.dao?.name ?? "DAO")
        .navigationBarTitleDisplayMode(.inline)
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
