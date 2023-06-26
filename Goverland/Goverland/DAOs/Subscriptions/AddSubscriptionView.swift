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
        if let totalDaos = dataSource.totalDaos.map(String.init) {
            return "Search \(totalDaos) DAOs by name"
        }
        return ""
    }

    var body: some View {
        VStack {
            if dataSource.searchText == "" {
                if !dataSource.failedToLoadInitially {
                    GroupedDaosView(dataSource: dataSource)
                } else {
                    RetryInitialLoadingView(dataSource: dataSource)
                }
            } else {
                DaosSearchListView(dataSource: dataSource)
            }
        }
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
        .padding(.horizontal, 20)
        .searchable(text: $dataSource.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchPrompt)
        .onAppear() {
            dataSource.refresh()
            Tracker.track(.addSubscriptionView)
        }
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
