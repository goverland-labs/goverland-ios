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
    
    case avtivityView = "activity_view"
    case introView = "intro_view"
    case searchDaoView = "search_dao_view"
    case launchTerms = "launch_terms"
}
