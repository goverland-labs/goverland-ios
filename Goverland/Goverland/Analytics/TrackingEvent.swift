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
    case onboardingFollowFromSearch = "onboarding_follow_from_search"
    case onboardingFollowFromCard = "onboarding_follow_from_card"
    case screenOnboardingCategoryDaos = "screen_onboarding_category_daos"
    case onboardingFollowFromCtgList = "onboarding_follow_from_ctg_list"
    case onboardingFollowFromCtgSearch = "onboarding_follow_from_ctg_search"

    case screenOnbaordingPushNotifications = "screen_onboarding_push_notifications"
    case onboardingYesNotifications = "onboarding_yes_notifications"
    case onboardingNoNotifications = "onboarding_no_notifications"


    // MARK: - Inbox


    // MARK: - DAO Info

    // MARK: - Search
    case screenSearchDaos = "screen_search_daos"
    case searchDaosFollowFromSearch = "search_daos_follow_from_search"
    case searchDaosFollowFromCard = "search_daos_follow_from_card"

    case screenSearchDaosCtgDaos = "screen_search_daos_ctg_daos"
    case searchDaosFollowFromCtgList = "search_daos_follow_from_ctg_list"
    case searchDaosFollowFromCtgSearch = "search_daos_follow_from_ctg_search"

    case searchDaosOpenDaoFromSearch = "search_daos_open_dao_from_search"
    case searchDaosOpenDaoFromCard = "search_daos_open_dao_from_card"
    case searchDaosOpenDaoFromCtgList = "search_daos_open_dao_from_ctg_list"
    case searchDaosOpenDaoFromCtgSearch = "search_daos_open_dao_from_ctg_search"

    // MARK: - Followed DAOs
    case screenFollowedDaos = "screen_followed_daos"
    case screenFollowedDaosEmpty = "screen_followed_daos_empty"
    case followedDaosUnfollow = "followed_daos_unfollow"
    case followedDaosRefollow = "followed_daos_refollow"
    case followedDaosOpenDao = "followed_daos_open_dao"

    case screenFollowedDaosAdd = "screen_followed_daos_add"
    case followedAddFollowFromSearch = "followed_add_follow_from_search"
    case followedAddFollowFromCard = "followed_add_follow_from_card"

    case screenFollowedAddCtg = "screen_followed_add_ctg"
    case followedAddFollowFromCtgList = "followed_add_follow_from_ctg_list"
    case followedAddFollowFromCtgSearch = "followed_add_follow_from_ctg_search"

    case followedAddOpenDaoFromSearch = "followed_add_open_dao_from_search"
    case followedAddOpenDaoFromCard = "followed_add_open_dao_from_card"
    case followedAddOpenDaoFromCtgList = "followed_add_open_dao_from_ctg_list"
    case followedAddOpenDaoFromCtgSearch = "followed_add_open_dao_from_ctg_search"

    // MARK: - Settings
    case screenSettings = "screen_settings"
    case settingsOpenTwitter = "settings_open_twitter"
    case settingsOpenDiscord = "settings_open_discord"
    case settingsOpenEmail = "settings_open_email"

    case screenNotifications = "screen_notifications"
    case settingsEnableGlbNotifications = "settings_enable_glb_notifications"
    case settingsDisableGlbNotifications = "settings_disable_glb_notifications"

    case screenAbout = "screen_about"
    case settingsOpenPrivacyPolicy = "settings_open_privacy_policy"
    case settingsOpenTerms = "settings_open_terms"

    case screenHelpUsGrow = "screen_help_us_grow"
    case settingsRateTheApp = "settings_rate_the_app"

    case screenAdvancedSettings = "screen_advanced_settings"
    case settingsDisableTracking = "settings_disable_tracking"


    // LEGACY. Remove iteratively
    case inboxView = "inbox_view"
    case daoInfoScreenView = "dao_info_screen_view"

    case searchProposalView = "search_proposal_view"

    case snapshotProposalView = "snapshot_proposal_detail_view"
}
