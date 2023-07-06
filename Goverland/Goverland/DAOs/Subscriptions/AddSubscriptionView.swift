//
//  AddSubscriptionView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.06.23.
//

import SwiftUI

struct AddSubscriptionView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var dataSource = GroupedDaosDataSource()

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
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
