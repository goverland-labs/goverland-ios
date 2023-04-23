//
//  TreasuryListItemContentView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI

struct TreasuryListItemContentView: View {
    let event: TreasuryEvent
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let txContent = event.content as? TreasuryEventsTXContent {
                    TreasuryEventsTXView(content: txContent)
                } else if let nftContent = event.content as? TreasuryEventsNFTContent {
                    TreasuryEventsNFTView(content: nftContent)
                }
                
                Text(event.transactionStatus.localizedName)
                    .foregroundColor(event.transactionStatus == .success ? .primaryDim : .dangerText)
                    .font(.footnoteRegular)
                    .lineLimit(1)
            }
            Spacer()
            DaoPictureView(daoImage: event.image, imageSize: 46)
        }
    }
}

struct TreasuryEventsTXView: View {
    let content: TreasuryEventsTXContent
    
    var body: some View {
        Text(content.amount)
            .foregroundColor(.textWhite)
            .font(.headlineSemibold)
            .lineLimit(2)
    }
}

struct TreasuryEventsNFTView: View {
    let content: TreasuryEventsNFTContent
    
    var body: some View {
        ZStack {
            if let name = content.user.ensName {
                Text(name)
                    .truncationMode(.tail)
            } else {
                Text(content.user.address)
                    .truncationMode(.middle)
            }
        }
        .foregroundColor(.textWhite)
        .font(.headlineSemibold)
        .lineLimit(2)
    }
}

struct TreasuryListItemContentView_Previews: PreviewProvider {
    static var previews: some View {
        TreasuryListItemContentView(event: .init(id: UUID(), sender: .init(address: "", image: nil, name: ""), date: Date(), type: .nft, status: .received, transactionStatus: .failed, content: TreasuryEventsTXContent(amount: ""), image: nil))
    }
}
