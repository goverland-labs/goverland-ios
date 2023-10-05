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
    let privacy: Privacy?
    let snapshot: String
    let state: State

    // Swift can automatically decode urls with special characters.
    // One option is to decode manually using percent-encoding, but for now we will make it a string
    let link: String

    let scores: [Double]
    let scoresTotal: Double
    let votes: Int
    let dao: Dao
    let timeline: [TimelineEvent]

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

    enum Privacy: String, Decodable {
        case shutter
        case none = ""
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
        case privacy
        case snapshot
        case state
       // case strategies
        case link
        case scores
        case scoresTotal = "scores_total"
        case votes
        case dao
        case timeline
    }

    static func == (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    init(id: String, 
         ipfs: String,
         author: User,
         created: Date,
         type: ProposalType,
         title: String,
         body: [ProposalBody],
         discussion: String?,
         choices: [String],
         symbol: String?,
         votingStart: Date,
         votingEnd: Date,
         quorum: Int,
         privacy: Privacy?,
         snapshot: String,
         state: State,
         link: String,
         scores: [Double],
         scoresTotal: Double,
         votes: Int,
         dao: Dao,
         timeline: [TimelineEvent])
    {
        self.id = id
        self.ipfs = ipfs
        self.author = author
        self.created = created
        self.type = type
        self.title = title
        self.body = body
        self.discussion = discussion
        self.choices = choices
        self.symbol = symbol
        self.votingStart = votingStart
        self.votingEnd = votingEnd
        self.quorum = quorum
        self.privacy = privacy
        self.snapshot = snapshot
        self.state = state
        self.link = link
        self.scores = scores
        self.scoresTotal = scoresTotal
        self.votes = votes
        self.dao = dao
        self.timeline = timeline
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.ipfs = try container.decode(String.self, forKey: .ipfs)

        do {
            self.author = try container.decode(User.self, forKey: .author)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `author`: Proposal ID: \(id)")
        }

        self.created = try container.decode(Date.self, forKey: .created)

        do {
            self.type = try container.decode(ProposalType.self, forKey: .type)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `type`: Proposal ID: \(id)")
        }

        self.title = try container.decode(String.self, forKey: .title)

        do {
            self.body = try container.decode([ProposalBody].self, forKey: .body)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `body`: Proposal ID: \(id)")
        }

        self.discussion = try? container.decodeIfPresent(String.self, forKey: .discussion)
        self.choices = try container.decode([String].self, forKey: .choices)
        self.symbol = try? container.decodeIfPresent(String.self, forKey: .symbol)
        self.votingStart = try container.decode(Date.self, forKey: .votingStart)
        self.votingEnd = try container.decode(Date.self, forKey: .votingEnd)
        self.quorum = try container.decode(Int.self, forKey: .quorum)

        do {
            self.privacy = try container.decodeIfPresent(Privacy.self, forKey: .privacy)
        } catch {
            logError(GError.errorDecodingData(error: error, context: "Decoding `privacy`: Proposal ID: \(id)"))
            self.privacy = nil
        }

        self.snapshot = try container.decode(String.self, forKey: .snapshot)
        
        do {
            self.state = try container.decode(State.self, forKey: .state)
        } catch {
            throw GError.errorDecodingData(error: error, context: "Decoding `state`: Proposal ID: \(id)")
        }

        self.link = try container.decode(String.self, forKey: .link)
        self.scores = try container.decode([Double].self, forKey: .scores)
        self.scoresTotal = try container.decode(Double.self, forKey: .scoresTotal)
        self.votes = try container.decode(Int.self, forKey: .votes)

        do {
            self.dao = try container.decode(Dao.self, forKey: .dao)
        } catch {
            if error is GError {
                throw(error)
            } else {
                throw(GError.errorDecodingData(error: error, context: "Decoding `dao`. Proposal ID: \(id)"))
            }
        }

        do {
            self.timeline = try container.decode([TimelineEvent].self, forKey: .timeline)
        } catch {
            throw(GError.errorDecodingData(error: error, context: "Decoding `timeline`. Proposal ID: \(id)"))
        }
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
        privacy: Proposal.Privacy.none,
        snapshot: "43600919",
        state: .active,
        //strategies: [],
        link: "https://snapshot.org/#/aavegotchi.eth/proposal/0x17b63fde4c0045768a12dc14c8a09b2a2bc6a5a7df7ef392e82e291904784e02",
        scores: [1742479.9190794732, 626486.0352702027],
        scoresTotal: 2368965.954349676,
        votes: 731,
        dao: .aave,
        timeline: [])
}
