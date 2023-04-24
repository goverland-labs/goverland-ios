//
//  TreasuryListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI

struct TreasuryListItemHeaderView: View {
    let event: InboxEvent

    var data: TreasuryEventData {
        event.data as! TreasuryEventData
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: data.sender)
                DateView(date: event.date)
            }
            Spacer()
            HStack(spacing: 6) {
                ReadIndicatior()
                TreasuryStatusView(status: data.status, transactionStatus: data.transactionStatus)
            }
        }
    }
}

fileprivate struct ReadIndicatior: View {
    var body: some View {
        Circle()
            .fill(Color.primary)
            .frame(width: 4, height: 4)
    }
}

struct TreasuryListItemHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TreasuryListItemHeaderView(event: .treasury1)
    }
}
