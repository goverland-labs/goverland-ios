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
    @StateObject private var dataSource = GroupedDaosDataSource()
    /// This view should have own active sheet manager as it is already presented in a popover
    @StateObject private var activeSheetManger = ActiveSheetManager()

    private var searchPrompt: String {
        if let total = dataSource.totalDaos.map(String.init) {
            return "Search for \(total) DAOs by name"
        }
        return ""
    }

    var body: some View {
        VStack {
            if dataSource.searchText == "" {
                if !dataSource.failedToLoadInitially {
                    GroupedDaosView(dataSource: dataSource,
                                    onDaoImageTap: { dao in activeSheetManger.activeSheet = .daoInfo(dao) },
                                    onFollowToggleFromCard: { if $0 { Tracker.track(.followedAddFollowFromCard) } },
                                    onCategoryListAppear: { Tracker.track(.screenFollowedAddCtg) },
                                    onFollowToggleFromCategoryList: { if $0 { Tracker.track(.followedAddFollowFromCtgList) } },
                                    onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.followedAddFollowFromCtgSearch) } })
                } else {
                    RetryInitialLoadingView(dataSource: dataSource)
                }
            } else {
                DaosSearchListView(dataSource: dataSource, onFollowToggle: { didFollow in
                    if didFollow {
                        Tracker.track(.followedAddFollowFromSearch)
                    }
                })
            }
        }
        .searchable(text: $dataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
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
        .sheet(item: $activeSheetManger.activeSheet) { item in
            NavigationStack {
                switch item {
                case .daoInfo(let dao):
                    DaoInfoView(dao: dao)
                default:
                    // should not happen
                    EmptyView()
                }
            }
            .accentColor(.primary)
        }
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
