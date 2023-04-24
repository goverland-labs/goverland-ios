//
//  TreasuryListItemContentView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI

struct TreasuryListItemContentView: View {
    let data: TreasuryEventData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                switch data.type {
                case .erc20, .native:
                    TreasuryEventsTXView(content: data.content as! TreasuryEventData.TxContent)
                case .nft:
                    TreasuryEventsNFTView(content: data.content as! TreasuryEventData.NFTContent)
                }
                
                Text(data.transactionStatus.localizedName)
                    .foregroundColor(data.transactionStatus == .success ? .primaryDim : .dangerText)
                    .font(.footnoteRegular)
                    .lineLimit(1)
            }
            Spacer()
            // TODO: rename
            DaoPictureView(daoImage: data.image, imageSize: 46)
        }
    }
}

struct TreasuryEventsTXView: View {
    let content: TreasuryEventData.TxContent
    
    var body: some View {
        Text(content.amount)
            .foregroundColor(.textWhite)
            .font(.headlineSemibold)
            .lineLimit(2)
    }
}

struct TreasuryEventsNFTView: View {
    let content: TreasuryEventData.NFTContent
    
    var body: some View {
        ZStack {
            if let name = content.user.ensName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(content.user.address.short)
            }
        }
        .foregroundColor(.textWhite)
        .font(.headlineSemibold)
        .lineLimit(1)
    }
}
