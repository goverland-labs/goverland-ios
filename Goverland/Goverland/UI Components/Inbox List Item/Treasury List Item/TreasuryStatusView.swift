//
//  TreasuryStatusView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//  Copyright © Goverland Inc. All rights reserved.
//
//
//import SwiftUI
//
//struct TreasuryStatusView: View {
//    let status: TreasuryEventData.EventStatus
//    let transactionStatus: TreasuryEventData.TransactionStatus
//    
//    var body: some View {
//        switch status {
//        case .sent:
//            HStack(spacing: 4) {
//                Image(systemName: transactionStatus == .success ? "arrow.up.right" : "xmark")
//                    .font(.system(size: 9))
//                    .foregroundColor(transactionStatus == .success ? .onPrimary : .textWhite)
//                Text(status.localizedName)
//                    .font(.caption2Semibold)
//                    .foregroundColor(transactionStatus == .success ? .onPrimary : .textWhite)
//                    .lineLimit(1)
//            }
//            .padding([.leading, .trailing], 9)
//            .padding([.top, .bottom], 3)
//            .background(Capsule()
//                .fill(transactionStatus == .success ? Color.primary : Color.fail))
//            
//        case .received:
//            HStack(spacing: 4) {
//                Image(systemName: "arrow.down.left")
//                    .font(.system(size: 9))
//                    .foregroundStyle(Color.textWhite)
//                Text(status.localizedName)
//                    .font(.caption2Semibold)
//                    .foregroundStyle(Color.textWhite)
//                    .lineLimit(1)
//            }
//            .padding([.leading, .trailing], 9)
//            .padding([.top, .bottom], 3)
//            .background(Capsule()
//                .fill(Color.success))
//        }
//    }
//}
