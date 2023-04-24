//
//  TreasuryListItemView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-21.
//

import SwiftUI

struct TreasuryListItemView: View {
    @State private var isRead = false
    let event: InboxEvent

    var data: TreasuryEventData {
        event.data as! TreasuryEventData
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.container)

            VStack(spacing: 12) {
                TreasuryListItemHeaderView(event: event)
                TreasuryListItemContentView(data: data)
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

struct TreasuryListItmeView_Previews: PreviewProvider {
    static var previews: some View {
        TreasuryListItemView(event: .treasury1)
    }
}
