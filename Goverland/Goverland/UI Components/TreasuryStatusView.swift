//
//  TreasuryStatusView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI

struct TreasuryStatusView: View {
    let status: TreasuryEventStatus //sent, received
    let transactionStatus: TreasuryEventTransactionStatus
    
    var body: some View {
        
        switch status {
        case .sent:
            HStack(spacing: 4) {
                Image(systemName: transactionStatus == .success ? "arrow.up.right" : "xmark")
                    .font(.system(size: 9))
                    .foregroundColor(transactionStatus == .success ? .onPrimary : .textWhite)
                Text(status.localizedName)
                    .font(.caption2Semibold)
                    .foregroundColor(transactionStatus == .success ? .onPrimary : .textWhite)
                    .lineLimit(1)
            }
            .padding([.leading, .trailing], 9)
            .padding([.top, .bottom], 3)
            .background(Capsule()
                .fill(transactionStatus == .success ? Color.primary : Color.fail))
            
        case .received:
            HStack(spacing: 4) {
                Image(systemName: "arrow.down.left")
                    .font(.system(size: 9))
                    .foregroundColor(.textWhite)
                Text(status.localizedName)
                    .font(.caption2Semibold)
                    .foregroundColor(.textWhite)
                    .lineLimit(1)
            }
            .padding([.leading, .trailing], 9)
            .padding([.top, .bottom], 3)
            .background(Capsule()
                .fill(Color.success))
        }
    }
}
