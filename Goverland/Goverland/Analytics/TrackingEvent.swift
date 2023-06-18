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
    case daoInfoScreenView = "dao_info_screen_view"
    case enablePushNotificationsView = "enable_push_notifications_view"
    case followCategoryDaosView = "follow_category_daos_view"
    case followListDaoView = "follow_list_dao_view"
    case introView = "intro_view"
    case launchTerms = "launch_terms"
    case searchDaoView = "search_dao_view"
    case searchProposalView = "search_proposal_view"
    case selectDaoView = "select_dao_view"
    case settingsAboutView = "settings_about_view"
    case settingsAdvancedView = "settings_advanced_view"
    case settingsAppearanceView = "settings_appearance_view"
    case settingsHelpUsGrowView = "settings_help_us_grow_view"
    case settingsPushNotificationsView = "settings_push_notifications_view"
    case settingsView = "settings_view"
    case snapshotProposalView = "snapshot_proposal_detail_view"
}
