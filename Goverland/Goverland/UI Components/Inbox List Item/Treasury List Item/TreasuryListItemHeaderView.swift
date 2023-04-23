//
//  TreasuryListItemHeaderView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI

struct TreasuryListItemHeaderView: View {
    let event: TreasuryEvent
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                IdentityView(user: event.sender)
                DateView(date: event.date)
            }
            Spacer()
            HStack(spacing: 6) {
                ReadIndicatior()
                TreasuryStatusView(status: event.status, transactionStatus: event.transactionStatus)
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
        TreasuryListItemHeaderView(event: .init(id: UUID(), sender: .init(address: "", image: nil, name: ""), date: Date(), type: .nft, status: .received, transactionStatus: .failed, content: TreasuryEventsTXContent(amount: ""), image: nil))
    }
}
