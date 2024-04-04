//
//  Vote.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-07-06.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

struct Vote<ChoiceType: Decodable>: Identifiable, Decodable {
    let id: String
    let voter: User
    let votingPower: Double
    let choice: ChoiceType
    let message: String?
    
    init(id: String,
         voter: User,
         votingPower: Double,
         choice: ChoiceType,
         message: String?) {
        self.id = id
        self.voter = voter
        self.votingPower = votingPower
        self.choice = choice
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case voter
        case votingPower = "vp"
        case choice
        case message = "reason"
    }
}

struct VoteSubmission: Decodable {
    let id: String
    let ipfs: String
}

extension Vote {
    func choiceStr(for proposal: Proposal) -> String? {
        switch proposal.type {
        case .basic, .singleChoice:
            if let choice = choice as? Int, choice <= proposal.choices.count {
                return String(proposal.choices[choice - 1])
            }
        case .approval, .rankedChoice:
            if let choice = choice as? [Int] {
                return choice.map { String($0) }.joined(separator: ", ")
            }
        case .weighted, .quadratic:
            if let choice = choice as? [String: Double] {
                let total = choice.values.reduce(0, +)
                return choice.map { "\(Utils.percentage(of: $0.value, in: total)) for \($0.key)" }.joined(separator: ", ")
            }
        }

        if proposal.privacy == .shutter {
            // result is encrepted. fallback case
            if let choice = choice as? String {
                return choice
            }
        }

        logError(GError.failedVotesDecoding(proposalID: proposal.id))
        return nil
    }
}
