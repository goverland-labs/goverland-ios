//
//  ProposalSummary.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 19.08.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

struct ProposalSummary: Decodable {
    let summaryMarkdown: String

    enum CodingKeys: String, CodingKey {
        case summaryMarkdown = "summary_markdown"
    }
}
