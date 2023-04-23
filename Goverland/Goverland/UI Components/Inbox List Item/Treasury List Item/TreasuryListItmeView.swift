//
//  TreasuryListItmeView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-21.
//

import SwiftUI

struct TreasuryListItmeView: View {
    @StateObject private var data = TreasuryDataService()

    var body: some View {
        List(0..<data.events.count, id: \.self) { index in
            if index == data.events.count - 1 && data.hasNextPageURL() {
                EmptyView()
                    .redacted(reason: .placeholder)
                    .onAppear {
                        data.getEvents()
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.container)
                    VStack(spacing: 12) {
                        TreasuryListItemHeaderView(event: data.events[index])
                        TreasuryListItemContentView(event: data.events[index])
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, -5)
                .padding(.top, 10)
            }
        }
        .refreshable {
            data.getEvents()
        }
    }
}

struct TreasuryListItmeView_Previews: PreviewProvider {
    static var previews: some View {
        TreasuryListItmeView()
    }
}
