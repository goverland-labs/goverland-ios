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
    case insights

    var localizedName: String {
        switch self {
        case .activity:
            return "Activity"
        case .about:
            return "About"
        case .insights:
            return "Insights"
            
        }
    }
}

struct DaoInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var dataSource: DaoInfoDataSource
    @State private var filter: DaoInfoFilter = .activity

    var dao: Dao? { dataSource.dao }

    init(daoID: UUID) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(daoID: daoID))
    }

    init(dao: Dao) {
        _dataSource = StateObject(wrappedValue: DaoInfoDataSource(dao: dao))
    }
    
    var body: some View {
        VStack {
            if dataSource.isLoading {
                // Unfortunately shimmer or reducted view here breaks presentation in a popover view
                ProgressView()
                    .foregroundColor(.textWhite20)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource)
            } else if let dao = dao {
                DaoInfoScreenHeaderView(dao: dao)
                    .padding(.horizontal)
                    .padding(.bottom)

                FilterButtonsView<DaoInfoFilter>(filter: $filter) { _ in }
                    .padding(.bottom, 4)

                switch filter {
                case .activity: DaoInfoEventsView(dao: dao)
                case .about: DaoInfoAboutDaoView(dao: dao)
                case .insights: DaoInsightsView(dao: dao)
                }
            }
        }
        .navigationTitle(dataSource.dao?.name ?? "DAO")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            if let dao = dao {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        DaoSharingMenu(dao: dao)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.textWhite)
                            .fontWeight(.bold)
                            .frame(height: 20)
                    }
                }
            }
        }
    }
}

struct DaoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DaoInfoView(daoID: UUID())
    }
}
