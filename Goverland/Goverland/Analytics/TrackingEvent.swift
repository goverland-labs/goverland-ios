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
    case onboardingOpenDaoFromSearch = "onboarding_open_dao_from_search"
    case onboardingFollowFromCard = "onboarding_follow_from_card"
    case onboardingOpenDaoFromCard = "onboarding_open_dao_from_card"

    case screenOnboardingCategoryDaos = "screen_onboarding_category_daos"
    case onboardingFollowFromCtgList = "onboarding_follow_from_ctg_list"
    case onboardingOpenDaoFromCtgList = "onboarding_open_dao_from_ctg_list"
    case onboardingFollowFromCtgSearch = "onboarding_follow_from_ctg_search"
    case onboardingOpenDaoFromCtgSearch = "onboarding_open_dao_from_ctg_search"

    case screenOnbaordingPushNotifications = "screen_onboarding_push_notifications"
    case onboardingYesNotifications = "onboarding_yes_notifications"
    case onboardingNoNotifications = "onboarding_no_notifications"

    // MARK: - Dashboard
    case screenDashboard = "screen_dashboard"
    case screenDashHotList = "screen_dash_hot_list"
    // Hot Proposals
    case dashHotOpenPrp = "dash_hot_open_prp"
    case dashHotOpenDao = "dash_hot_open_dao"
    case dashHotOpenPrpFromList = "dash_hot_open_prp_from_list"
    case dashHotOpenDaoFromList = "dash_hot_open_dao_from_list"
    // New DAOs
    case dashNewDaoOpen = "dash_newdao_open"
    case dashNewDaoFollow = "dash_newdao_follow"
    case screenDashNewDao = "screen_dash_newdao"
    case dashNewDaoOpenFromList = "dash_newdao_open_from_list"
    case dashNewDaoFollowFromList = "dash_newdao_follow_from_list"
    case dashNewDaoOpenFromSearch = "dash_newdao_open_from_search"
    case dashNewDaoFollowFromSearch = "dash_newdao_follow_from_search"

    // MARK: - Inbox
    case screenInbox = "screen_inbox"
    case screenInboxEmpty = "screen_inbox_empty"
    case inboxEventOpen = "inbox_event_open"
    case inboxEventOpenDao = "inbox_event_open_dao"
    case inboxEventArchive = "inbox_event_archive"
    case inboxEventMarkRead = "inbox_event_mark_read"
    
    // MARK: - Archive
    case screenArchive = "screen_archive"
    case screenArchiveEmpty = "screen_archive_empty"
    case archiveEventUnarchive = "archive_event_unarchive"
    case archiveEventMarkRead = "archive_event_mark_read"

    // MARK: - DAO Info
    case daoFollow = "dao_follow"
    // Events
    case screenDaoFeed = "screen_dao_feed"
    case daoEventOpen = "dao_event_open"

    // - About
    case screenDaoAbout = "screen_dao_about"
    case daoOpenWebsite = "dao_open_website"
    case daoOpenShapshot = "dao_open_shapshot"
    case daoOpenCoingecko = "dao_open_coingecko"
    case daoOpenTwitter = "dao_open_twitter"
    case daoOpenGithub = "dao_open_github"
    case daoOpenTerms = "dao_open_terms"
    
    // - Insights
    case screenDaoInsights = "screen_dao_insights"


    // MARK: - Snapshot Proposal
    case screenSnpDetails = "screen_snp_details"
    case snpDetailsShowDao = "snp_details_show_dao"
    case snpDetailsShowFullDscr = "snp_details_show_full_dscr"
    case snpDetailsVote = "snp_details_vote"
    case snpDetailsContinueOnboarding = "snp_details_continue_onboarding"

    // MARK: - Snapshot Proposal Votes
    case screenSnpVoters = "screen_snp_voters"

    // MARK: - Search DAO
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

    // MARK: - Search Proposal
    case screenSearchPrp = "screen_search_prp"
    case searchPrpOpenFromSearch = "search_prp_open_from_search"
    case searchPrpOpenFromCard = "search_prp_open_from_card"
    case searchPrpOpenDaoFromSearch = "search_prp_open_dao_from_search"
    case searchPrpOpenDaoFromCard = "search_prp_open_dao_from_card"

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
    case settingsShareTweet = "settings_share_a_tweet"

    case screenAdvancedSettings = "screen_advanced_settings"
    case settingsDisableTracking = "settings_disable_tracking"
}
