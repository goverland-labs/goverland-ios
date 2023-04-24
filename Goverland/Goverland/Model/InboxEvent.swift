//
//  InboxEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-06.
//

import SwiftUI
import Combine

enum EventType: String, Decodable {
    case vote
    case treasury
}

struct InboxEvent: Identifiable, Decodable {
    let id: UUID
    let date: Date
    let type: EventType
    let daoImage: URL?
    let data: EventData
    
    init(id: UUID,
         date: Date,
         type: EventType,
         daoImage: URL?,
         data: EventData) {
        self.id = id
        self.date = date
        self.type = type
        self.daoImage = daoImage
        self.data = data
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case type
        case daoImage
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.type = try container.decode(EventType.self, forKey: .type)
        self.daoImage = try container.decode(URL.self, forKey: .daoImage)

        switch type {
        case .vote:
            self.data = try container.decode(VoteEventData.self, forKey: .data)
        case .treasury:
            self.data = try container.decode(TreasuryEventData.self, forKey: .data)
        }
    }
}

protocol EventData {}

// MARK: - Vote

struct VoteEventData: EventData, Decodable {
    let user: User
    let status: EventStatus
    let content: VoteContent
    let meta: VoteMeta

    enum EventStatus: String, Decodable {
        case activeVote
        case executed
        case failed
        case queued
        case succeeded
        case defeated
        // TODO: add localizedName
    }

    struct VoteContent: Decodable {
        let title: String
        let subtitle: String
        let warningSubtitle: String?
    }

    struct VoteMeta: Decodable {
        let voters: Int
        let quorum: String
        let voted: Bool
    }
}


// MARK: - Treasury

protocol TreasuryEventTypedContent {}

struct TreasuryEventData: EventData, Decodable {
    let sender: User
    let status: EventStatus
    let transactionStatus: TransactionStatus
    let image: URL?
    let type: TreasuryEventType
    let content: TreasuryEventTypedContent

    fileprivate init(
        sender: User,
        status: EventStatus,
        transactionStatus: TransactionStatus,
        image: URL?,
        type: TreasuryEventType,
        content: TreasuryEventTypedContent) {
            self.sender = sender
            self.status = status
            self.transactionStatus = transactionStatus
            self.image = image
            self.type = type
            self.content = content
    }

    enum CodingKeys: CodingKey {
        case sender
        case status
        case transactionStatus
        case image
        case type
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sender = try container.decode(User.self, forKey: .sender)
        self.status = try container.decode(EventStatus.self, forKey: .status)
        self.transactionStatus = try container.decode(TransactionStatus.self, forKey: .transactionStatus)
        self.image = try container.decode(URL.self, forKey: .image)
        self.type = try container.decode(TreasuryEventType.self, forKey: .type)

        switch type {
        case .native, .erc20:
            self.content = try container.decode(TxContent.self, forKey: .content)
        case .nft:
            self.content = try container.decode(NFTContent.self, forKey: .content)
        }
    }

    enum EventStatus: String, Decodable {
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

    enum TransactionStatus: String, Decodable {
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

    enum TreasuryEventType: String, Decodable {
        case native
        case erc20
        case nft
    }

    struct TxContent: TreasuryEventTypedContent, Decodable {
        let amount: String
    }

    struct NFTContent: TreasuryEventTypedContent, Decodable {
        let user: User
    }
}

// MARK: - Mock data

extension InboxEvent {
    static let vote1 = InboxEvent(
        id: UUID(),
        date: .now,
        type: .vote,
        daoImage: URL(string: ""),
        data: VoteEventData(
            user: User.flipside,
            status: .activeVote,
            content: VoteEventData.VoteContent(
                title: "Lets party!",
                subtitle: "Who is in?",
                warningSubtitle: "No party poopers please"),
            meta: VoteEventData.VoteMeta(
                voters: 53,
                quorum: "120%",
                voted: true)))

    static let treasury1 = InboxEvent(
        id: UUID(),
        date: .now,
        type: .treasury,
        daoImage: URL(string: ""),
        data: TreasuryEventData(
            sender: User.flipside,
            status: .received,
            transactionStatus: .success,
            image: URL(string: ""),
            type: .erc20,
            content: TreasuryEventData.TxContent(amount: "20K"))
    )
}
