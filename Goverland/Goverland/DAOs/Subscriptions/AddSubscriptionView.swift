//
//  AddSubscriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.06.23.
//

import SwiftUI

/// This view is always presented in a popover
struct AddSubscriptionView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var dataSource = GroupedDaosDataSource.shared
    @StateObject private var searchDataSource = DaosSearchDataSource.shared

    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManager = ActiveSheetManager()

    private var searchPrompt: String {
        if let total = dataSource.totalDaos.map(String.init) {
            return "Search for \(total) DAOs by name"
        }
        return ""
    }

    var body: some View {
        VStack {
            if searchDataSource.searchText == "" {
                if !dataSource.failedToLoadInitialData {
                    GroupedDaosView(activeSheetManager: activeSheetManager,
                                    onSelectDaoFromGroup: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCard) },
                                    onSelectDaoFromCategoryList: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgList) },
                                    onSelectDaoFromCategorySearch: { dao in activeSheetManager.activeSheet = .daoInfo(dao); Tracker.track(.followedAddOpenDaoFromCtgSearch) },

                                    onFollowToggleFromCard: { if $0 { Tracker.track(.followedAddFollowFromCard) } },
                                    onFollowToggleFromCategoryList: { if $0 { Tracker.track(.followedAddFollowFromCtgList) } },
                                    onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.followedAddFollowFromCtgSearch) } },

                                    onCategoryListAppear: { Tracker.track(.screenFollowedAddCtg) })
                } else {
                    RetryInitialLoadingView(dataSource: dataSource)
                }
            } else {
                DaosSearchListView(onSelectDao: { dao in
                    activeSheetManager.activeSheet = .daoInfo(dao)
                    Tracker.track(.followedAddOpenDaoFromSearch)
                },
                                   onFollowToggle: { didFollow in
                    if didFollow {
                        Tracker.track(.followedAddFollowFromSearch)
                    }
                })
            }
        }
        .searchable(text: $searchDataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textWhite)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Follow DAOs")
                        .font(.title3Semibold)
                        .foregroundColor(Color.textWhite)
                }
            }
        }
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.screenFollowedDaosAdd)
        }
        .sheet(item: $activeSheetManager.activeSheet) { item in
            NavigationStack {
                switch item {
                case .daoInfo(let dao):
                    DaoInfoView(dao: dao)
                default:
                    // should not happen
                    EmptyView()
                }
            }
            .accentColor(.textWhite)
            .overlay {
                ToastView()
            }
        }
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
