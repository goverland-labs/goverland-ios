//
//  TrackingEvent.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

protocol Trackable {
    var eventName: String { get }
}

enum TrackingEvent: String, Trackable {
    var eventName: String { rawValue }

    // MARK: - Sign In
    case screenSignIn = "screen_sign_in"
    case signInWithWallet = "sign_in_with_wallet"
    case signInAsGuest = "sign_in_as_guest"
    case twoStepsSignedIn = "two_steps_signed_in"

    case screencConnectWallet = "screen_connect_wallet"
    case connectWalletShowQR = "connect_wallet_show_qr"
    case walletConnected = "wallet_connected"

    case screenReconnectWallet = "screen_reconnect_wallet"
    case reconnectWalletWrongWallet = "reconnect_wallet_wrong_wallet"
    case reconnectWalletSuccess = "reconnect_wallet_success"

    // MARK: - Push Notifications
    case screenPushNotifications = "screen_push_notifications"
    case notificationsYes = "notifications_yes"
    case notificationsNo = "notifications_no"

    // MARK: - Dashboard
    case screenDashboard = "screen_dashboard"
    // Followed DAOs with active vote
    case dashFollowedDaoActiveVoteOpenDao = "dash_followed_av_open_dao"
    // Hot Proposals
    case dashHotOpenDao = "dash_hot_open_dao"
    case dashHotOpenPrp = "dash_hot_open_prp"
    case screenDashHotList = "screen_dash_hot_list"
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
    // Popular DAOs
    case dashPopularDaoOpen = "dash_populardao_open"
    case dashPopularDaoFollow = "dash_populardao_follow"
    case screenDashPopularDao = "screen_dash_populardao"
    case dashPopularDaoOpenFromList = "dash_populardao_open_from_list"
    case dashPopularDaoFollowFromList = "dash_populardao_follow_from_list"
    case dashPopularDaoOpenFromSearch = "dash_populardao_open_from_search"
    case dashPopularDaoFollowFromSearch = "dash_populardao_follow_from_search"
    // Profile has voting power
    case dashCanVoteOpenDao = "dash_can_vote_open_dao"
    case dashCanVoteOpenPrp = "dash_can_vote_open_prp"
    case screenDashCanVote = "screen_dash_can_vote"
    case dashCanVoteOpenPrpFromList = "dash_can_vote_open_prp_from_list"
    case dashCanVoteOpenDaoFromList = "dash_can_vote_open_dao_from_list"

    // MARK: - Inbox
    case screenInbox = "screen_inbox"
    case screenInboxEmpty = "screen_inbox_empty"
    case screenInboxWelcome = "screen_inbox_welcome"
    case inboxEventOpen = "inbox_event_open"
    case inboxEventOpenDao = "inbox_event_open_dao"
    case inboxEventArchive = "inbox_event_archive"
    case inboxEventMarkRead = "inbox_event_mark_read"
    case inboxEventMarkUnread = "inbox_event_mark_unread"

    // MARK: - Archive
    case screenArchive = "screen_archive"
    case screenArchiveEmpty = "screen_archive_empty"
    case archiveEventOpen = "archive_event_open"
    case archiveEventUnarchive = "archive_event_unarchive"
    case archiveEventMarkRead = "archive_event_mark_read"
    case archiveEventMarkUnread = "archive_event_mark_unread"

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
    case daoOpenX = "dao_open_X"
    case daoOpenGithub = "dao_open_github"
    case daoOpenTerms = "dao_open_terms"
    
    // - Insights
    case screenDaoInsights = "screen_dao_insights"
    case daoInsightsMutualOpen = "dao_insights_mutual_open"
    case daoInsightsMutualFollow = "dao_insights_mutual_follow"


    // MARK: - Snapshot Proposal
    case screenSnpDetails = "screen_snp_details"
    case snpDetailsShowDao = "snp_details_show_dao"
    case snpDetailsShowFullDscr = "snp_details_show_full_dscr"
    case snpDetailsVote = "snp_details_vote"
    case snpDetailsContinueOnboarding = "snp_details_continue_onboarding"

    // MARK: - Snapshot Proposal Votes
    case screenSnpVoters = "screen_snp_voters"

    // MARK: - Terms view
    case screenSnpDaoTerms = "screen_snp_dao_terms"
    case snpDaoTermsAgree = "snp_dao_terms_agree"

    // MARK: - Cast your vote
    case screenSnpCastVote = "screen_snp_cast_vote"
    case screenSnpVoteSuccess = "screen_snp_vote_success"
    case snpSuccessVoteShareX = "snp_success_vote_share_x"
    case snpSuccessVoteShareWarpcast = "snp_success_vote_share_warpcast"

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

    // Recently Viewed DAOs
    case searchRecentDaoOpen = "search_recentdao_open"

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

    // MARK: - Profile
    case screenProfile = "screen_profile"
    case signOut = "sign_out"
    case deleteProfile = "delete_profile"
    case signOutDevice = "sign_out_device"
    case disconnect_WC_session = "disconnect_wc_session"
    case disconnectCoinbaseWallet = "disconnect_cb_wallet"
    
    // Votes
    case prfVotesOpenProposal = "prf_votes_open_proposal"
    case prfVotesOpenDao = "prf_votes_open_dao"
    case screenProfileVotesFull = "screen_profile_votes_full"
    case prfVotesFullOpenProposal = "prf_votes_full_open_proposal"
    case prfVotesFullOpenDao = "prf_votes_full_open_dao"

    // Achievements
    case screenAchievements = "screen_achievements"
    case screenAchievementDetails = "screen_achievement_details"
    case screenGuestAchievements = "screen_guest_achievements"

    // MARK: - Settings
    case screenSettings = "screen_settings"
    case settingsOpenX = "settings_open_X"
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
    case settingsShareXPost = "settings_share_X_post"

    case screenAdvancedSettings = "screen_advanced_settings"
    case settingsDisableTracking = "settings_disable_tracking"
    
    // MARK: - App Update
    case appUpdateBlockScreen = "screen_new_updates_available"
    case openAppStoreLink = "app_store_link_open"
    case openDiscordLink = "discord_link_open"
    
    // MARK: - Server Maintenance
    case screenMaintenance = "screen_maintenance"
    case screenMaintenanceOpenX = "screen_maintenance_open_X"
    case screenMaintenanceOpenDiscord = "screen_maintenance_open_discord"
}
