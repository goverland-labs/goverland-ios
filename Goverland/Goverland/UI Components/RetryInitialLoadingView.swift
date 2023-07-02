//
//  RetryInitialLoadingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.06.23.
//

import SwiftUI

protocol Refreshable: AnyObject {
    func refresh()
}

protocol Paginatable: AnyObject {
    func retryLoadMore()
}

// TODO: implement design
struct RetryInitialLoadingView: View {
    let dataSource: Refreshable

    var body: some View {
        VStack(alignment: .center) {
            Text("Sorry, we couldn’t load the data. Please try again.")
            PrimaryButton("Try again") {
                dataSource.refresh()
            }
        }
    }
}

struct RetryLoadMoreListItemView: View {
    let dataSource: Paginatable

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button("Load more") {
                dataSource.retryLoadMore()
            }
            .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 12)
    }
}
