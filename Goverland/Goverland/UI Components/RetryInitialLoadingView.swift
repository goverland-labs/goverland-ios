//
//  RetryInitialLoadingView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

protocol Refreshable: AnyObject {
    func refresh()
}

struct RetryInitialLoadingView: View {
    let dataSource: Refreshable
    let message: String
    // TODO: inject tracking event here

    init(dataSource: Refreshable,
         message: String = "Sorry, we couldn’t load the inital data") {
        self.dataSource = dataSource
        self.message = message
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                Image("looped-line")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width / 2)
                Text(message)
                    .font(.calloutRegular)
                    .foregroundStyle(Color.textWhite)
                Spacer()
                PrimaryButton("Try again") {
                    dataSource.refresh()
                }
                Spacer()
            }
            // this is needed as on iPad GeometryReader breaks VStack layout
            .frame(width: geometry.size.width - 32)
            .padding([.horizontal, .bottom], 16)
        }
    }
}

protocol Paginatable: AnyObject {
    func retryLoadMore()
}

struct RetryLoadMoreListItemView: View {
    let dataSource: Paginatable

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            RefreshIcon {
                dataSource.retryLoadMore()
            }            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}
