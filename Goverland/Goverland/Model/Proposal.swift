//
//  Proposal.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 17.06.23.
//

import Foundation
import SwiftDate

struct Proposal: Decodable, Hashable {
    let id: String
    let ipfs: String
    let author: User
    let created: Date
    let type: ProposalType
    let title: String
    let body: [ProposalBody]
    // TODO: fix after sync with backend
    let discussion: String?
    let choices: [String]
    let symbol: String?
    let votingStart: Date
    let votingEnd: Date
    let quorum: Int
    let snapshot: String
    let state: State
    let timeline: [TimelineEvent]
    //let strategies: [String]

    // Swift can automatically decode urls with special characters.
    // One option is to decode manually using percent-encoding, but for now we will make it a string
    let link: String
    let scores: [Double]
    let scoresTotal: Double
    let votes: Int
    let dao: Dao

    enum ProposalType: String, Decodable {
        case basic
        case singleChoice = "single-choice"
        case weighted
        case approval
        case quadratic
        case rankedChoice = "ranked-choice"
    }

    struct ProposalBody: Decodable {
        let type: BodyType
        let body: String

        enum BodyType: String, Decodable {
            case markdown
            case html
        }
    }

    enum State: String, Decodable {
        case active
        case closed
        case failed
        case succeeded
        case defeated
        case queued
        case pending
        case executed

        var localizedName: String {
            switch self {
            case .active: return "Active vote"
            case .closed: return "Closed"
            case .failed: return "Failed"
            case .succeeded: return "Succeeded"
            case .defeated: return "Defeated"
            case .queued: return "Queued"
            case .pending: return "Pending"
            case .executed: return "Executed"
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case ipfs
        case author
        case created
        case type
        case title
        case body
        case discussion
        case choices
        case symbol
        case votingStart = "voting_start"
        case votingEnd = "voting_end"
        case quorum
        case snapshot
        case state
        case timeline
       // case strategies
        case link
        case scores
        case scoresTotal = "scores_total"
        case votes
        case dao
    }

    static func == (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Mock data

extension Proposal {
    static let aaveTest = Proposal(
        id: "0x17b63fde4c0045768a12dc14c8a09b2a2bc6a5a7df7ef392e82e291904784e02",
        ipfs: "bafkreihkovc6tgarlxlxciigo7225kegbsdyipkjzlx62qmuibgrfqkts4",
        author: .aaveChan,
        created: .now - 5.days,
        type: .weighted,
        title: "Schedule all Act 1 Parcel Surveys (re-rolls)",
        body: [
            ProposalBody(type: .markdown, body: "Authors: Dr Wagmi | Forge | Vault#6629\nGotchiIDs: 16635\nQuorum requirement: 20% (9M)\nVote duration: 5 days\nDiscourse Thread: https://discord.com/channels/732491344970383370/1111329507987701871/1111329507987701871\n\nI propose that Parcel Re-rolls be scheduled and recurring every 12 weeks to complete ACT 1. Further survey rolls and tokenomics of Acts 2 and 3 can be proposed by Pixelcraft or the Aavegotchi DAO. This predictability will ensure investors have prior investment decisions honored and to be more confident in future investments. The Pixelcraft team continues to develop the Gotchiverse and GotchiGuardians which will create further sinks and a healthy, sustainable ecosystem. This will continue to push alchemica emissions away from channeling and into farming. It will allow Pixelcraft clear dates around which to target a Great Battle or similar climactic experience for the rounds. It also affords more confident participation in the alchemica spending competitions which have been very successful to date. \n\nHistorical Survey Dates: \nSurvey #1 (Initial Farm release): 7/20/2022 (25% of alchemica in act 1) \nSurvey #2: 3/3/2023 \n\nProposed Survey rolls (estimate based on Pixelcraft Shipping Fridays): 8.33% each: \nSurvey #3: 6/16/2023 \nSurvey #4: 9/8/2023 \nSurvey #5: 12/1/2023 \nSurvey #6: 2/24/2024 \nSurvey #7: 5/18/2024 \nSurvey #8: 8/10/2024 \nSurvey #9: 11/2/2024 (final survey of Act 1) \n\nReferences: Aavegotchi Medium Alchemica Report: https://aavegotchi.medium.com/top-secret-gotchus-alchemica-tokenomics-report-fc588cda9896 \nAavegotchi Bible Chapter 2 Alchemica Tokenomics: https://blog.aavegotchi.com/the-gotchiverse-game-bible-chapter-2/\n\n\nThanks\nDr Wagmi"),
            ProposalBody(type: .html, body: "<p>Authors: Dr Wagmi | Forge | Vault#6629\nGotchiIDs: 16635\nQuorum requirement: 20% (9M)\nVote duration: 5 days\nDiscourse Thread: <a href=\"https://discord.com/channels/732491344970383370/1111329507987701871/1111329507987701871\" target=\"_blank\">https://discord.com/channels/732491344970383370/1111329507987701871/1111329507987701871</a></p>\n\n<p>I propose that Parcel Re-rolls be scheduled and recurring every 12 weeks to complete ACT 1. Further survey rolls and tokenomics of Acts 2 and 3 can be proposed by Pixelcraft or the Aavegotchi DAO. This predictability will ensure investors have prior investment decisions honored and to be more confident in future investments. The Pixelcraft team continues to develop the Gotchiverse and GotchiGuardians which will create further sinks and a healthy, sustainable ecosystem. This will continue to push alchemica emissions away from channeling and into farming. It will allow Pixelcraft clear dates around which to target a Great Battle or similar climactic experience for the rounds. It also affords more confident participation in the alchemica spending competitions which have been very successful to date.</p>\n\n<p>Historical Survey Dates:\nSurvey #1 (Initial Farm release): 7/20/2022 (25% of alchemica in act 1)\nSurvey #2: 3/3/2023</p>\n\n<p>Proposed Survey rolls (estimate based on Pixelcraft Shipping Fridays): 8.33% each:\nSurvey #3: 6/16/2023\nSurvey #4: 9/8/2023\nSurvey #5: 12/1/2023\nSurvey #6: 2/24/2024\nSurvey #7: 5/18/2024\nSurvey #8: 8/10/2024\nSurvey #9: 11/2/2024 (final survey of Act 1)</p>\n\n<p>References: Aavegotchi Medium Alchemica Report: <a href=\"https://aavegotchi.medium.com/top-secret-gotchus-alchemica-tokenomics-report-fc588cda9896\" target=\"_blank\">https://aavegotchi.medium.com/top-secret-gotchus-alchemica-tokenomics-report-fc588cda9896</a>\nAavegotchi Bible Chapter 2 Alchemica Tokenomics: <a href=\"https://blog.aavegotchi.com/the-gotchiverse-game-bible-chapter-2/\" target=\"_blank\">https://blog.aavegotchi.com/the-gotchiverse-game-bible-chapter-2/</a></p>\n\n<p>Thanks\nDr Wagmi</p>\n")
        ],
        discussion: "https://discord.com/channels/732491344970383370/1111329507987701871/1111329507987701871",
        choices: ["Yes. Schedule all survey rolls.", "No. Don't schedule them."],
        symbol: "AAVE",
        votingStart: .now + 1.days,
        votingEnd: .now + 5.days,
        quorum: 0,
        snapshot: "43600919",
        state: .active,
        timeline: [],
        //strategies: [],
        link: "https://snapshot.org/#/aavegotchi.eth/proposal/0x17b63fde4c0045768a12dc14c8a09b2a2bc6a5a7df7ef392e82e291904784e02",
        scores: [1742479.9190794732, 626486.0352702027],
        scoresTotal: 2368965.954349676,
        votes: 731,
        dao: .aave)
}
