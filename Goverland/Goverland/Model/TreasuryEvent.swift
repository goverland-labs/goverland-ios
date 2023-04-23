//
//  TreasuryEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI
import Combine

struct TreasuryEvent: Identifiable, Decodable {
    let id: UUID
    let sender: User
    let date: Date
    let type: TreasuryEventType
    let status: TreasuryEventStatus
    let transactionStatus: TreasuryEventTransactionStatus
    let content: TreasuryEventContent?
    let image: URL?
    
    init(id: UUID,
         sender: User,
         date: Date,
         type: TreasuryEventType,
         status: TreasuryEventStatus,
         transactionStatus: TreasuryEventTransactionStatus,
         content: TreasuryEventContent,
         image: URL?) {
        self.id = id
        self.sender = sender
        self.date = date
        self.type = type
        self.status = status
        self.transactionStatus = transactionStatus
        self.content = content
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case sender
        case date
        case type
        case status
        case transactionStatus
        case content
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.sender = try container.decode(User.self, forKey: .sender)
        self.date = try container.decode(Date.self, forKey: .date)
        self.type = try container.decode(TreasuryEventType.self, forKey: .type)
        self.status = try container.decode(TreasuryEventStatus.self, forKey: .status)
        self.transactionStatus = try container.decode(TreasuryEventTransactionStatus.self, forKey: .transactionStatus)
        self.image = try container.decode(URL.self, forKey: .image)
        switch type {
        case .tx:
            self.content = try? container.decode(TreasuryEventsTXContent.self, forKey: .content)
        case .nft:
            self.content = try? container.decode(TreasuryEventsNFTContent.self, forKey: .content)
        }
        
    }
}

protocol TreasuryEventContent {}

struct TreasuryEventsNFTContent: TreasuryEventContent, Decodable {
    let user: User

    init(user: User) {
        self.user = user
    }
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}

struct TreasuryEventsTXContent: TreasuryEventContent, Decodable {
    let amount: String
    
    init(amount: String) {
        self.amount = amount
    }
}

enum TreasuryEventType: String, Decodable {
    case nft = "NFT"
    case tx
}

enum TreasuryEventStatus: String, Decodable {
    case sent
    case received
    
    var localizedName: String {
        switch self {
        case .sent:
            return "Sent"
        case .received:
            return "Received"
        }
    }
}

enum TreasuryEventTransactionStatus: String, Decodable {
    case failed
    case success
    
    var localizedName: String {
        switch self {
        case .failed:
            return "Failed"
        case .success:
            return "Success"
        }
    }
}

