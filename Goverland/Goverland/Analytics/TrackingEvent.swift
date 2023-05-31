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
    
    case inboxView = "inbox_view"
    case inboxDetailView = "inbox_detail_view"
    case daoInfoScreenView = "dao_info_screen_view"
    case enablePushNotificationsView = "enable_push_notifications_view"
    case followDaoListView = "follow_dao_list_view"
    case introView = "intro_view"
    case launchTerms = "launch_terms"
    case searchDaoView = "search_dao_view"
    case searchDiscussionView = "search_discussion_view"
    case searchVoteView = "search_vote_view"
    case selectDaoView = "select_dao_view"
    case settingsAboutView = "settings_about_view"
    case settingsAdvancedView = "settings_advanced_view"
    case settingsAppearanceView = "settings_appearance_view"
    case settingsHelpUsGrowView = "settings_help_us_grow_view"
    case settingsPushNotificationsView = "settings_push_notifications_view"
    case settingsView = "settings_view"
    case snapshotProposalView = "snapshot_proposal_detail_view"
}
