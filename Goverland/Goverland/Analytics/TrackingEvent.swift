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

    // MARK: - Onboarding
    case screenOnboardingFollowDaos = "screen_onboarding_follow_daos"
    case screenOnbaordingPushNotifications = "screen_onboarding_push_notifications"
    case onboardingYesNotifications = "onboarding_yes_notifications"
    case onboardingNoNotifications = "onboarding_no_notifications"
    case onboardingFollowFromSearch = "onboarding_follow_from_search"
    case onboardingFollowFromCard = "onboarding_follow_from_card"
    case screenOnboardingCategoryDaos = "screen_onboarding_category_daos"
    case onboardingFollowFromCtgList = "onboarding_follow_from_ctg_list"
    case onboardingFollowFromCtgSearch = "onboarding_follow_from_ctg_search"

    // MARK: - Search
    case screenSearchDaos = "screen_search_daos"
    case searchDaosFollowFromSearch = "search_daos_follow_from_search"
    case searchDaosFollowFromCard = "search_daos_follow_from_card"
    case screenSearchDaosCtgDaos = "screen_search_daos_ctg_daos"
    case searchDaosFollowFromCtgList = "search_daos_follow_from_ctg_list"
    case searchDaosFollowFromCtgSearch = "search_daos_follow_from_ctg_search"

    // MARK: - Followed DAOs
    case screenFollowedDaos = "screen_followed_daos"
    case followedDaosUnfollow = "followed_daos_unfollow"
    case followedDaosRefollow = "followed_daos_refollow"
    case screenFollowedDaosAdd = "screen_followed_daos_add"
    case followedAddFollowFromSearch = "followed_add_follow_from_search"
    case followedAddFollowFromCard = "followed_add_follow_from_card"
    case screenFollowedAddCtg = "screen_followed_add_ctg"
    case followedAddFollowFromCtgList = "followed_add_follow_from_ctg_list"
    case followedAddFollowFromCtgSearch = "followed_add_follow_from_ctg_search"


    // LEGACY. Remove iteratively
    case inboxView = "inbox_view"
    case daoInfoScreenView = "dao_info_screen_view"
    case introView = "intro_view"
    case launchTerms = "launch_terms"
    case searchProposalView = "search_proposal_view"
    case settingsAboutView = "settings_about_view"
    case settingsAdvancedView = "settings_advanced_view"
    case settingsAppearanceView = "settings_appearance_view"
    case settingsHelpUsGrowView = "settings_help_us_grow_view"
    case settingsPushNotificationsView = "settings_push_notifications_view"
    case settingsView = "settings_view"
    case snapshotProposalView = "snapshot_proposal_detail_view"
}
