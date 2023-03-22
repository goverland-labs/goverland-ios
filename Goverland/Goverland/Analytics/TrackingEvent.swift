//
//  TrackingEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import Foundation

protocol Trackable {
    var eventName: String { get }
}

enum TrackingEvent: String, Trackable {
    var eventName: String { rawValue }
    
    case avtivityView = "screen_activity_view"
    case introView = "screen_intro_view"
    case selectDaoView = "screen_select_dao_view"
    case launchTerms = "screen_launch_terms"
}
