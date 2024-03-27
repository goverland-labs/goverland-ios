//
//  VoterVotingPower.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 26.03.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

protocol VoterVotingPower: Identifiable {
    var voter: User { get }
    var votingPower: Double { get }

    init(voter: User, votingPower: Double)
}
