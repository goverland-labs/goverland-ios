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

    // MARK: - What's new
    case screenWhatsNew = "screen_whats_new"

    // MARK: - Sign In
    case screenSignIn = "screen_sign_in"
    case signInWithWallet = "sign_in_with_wallet"
    case signInAsGuest = "sign_in_as_guest"
    case twoStepsSignedIn = "two_steps_signed_in"

    // MARK: - Connect Wallet
    case screencConnectWallet = "screen_connect_wallet"
    case connectWalletShowQR = "connect_wallet_show_qr"
    case initiateRecommendedWltConnection = "initiate_recommended_wlt_connection"
    case walletConnected = "wallet_connected"

    // MARK: - Reconnect Wallet
    case screenReconnectWallet = "screen_reconnect_wallet"
    case reconnectWalletWrongWallet = "reconnect_wallet_wrong_wallet"
    case reconnectWalletSuccess = "reconnect_wallet_success"

    // MARK: - Download Wallet
    case downloadWallet = "download_wallet"

    // MARK: - Push Notifications
    case screenPushNotifications = "screen_push_notifications"
    case notificationsYes = "notifications_yes"
    case notificationsNo = "notifications_no"

    // MARK: - Dashboard
    case screenDashboard = "screen_dashboard"
    // Featured Proposal
    case dashFeaturedPrpOpenDao = "dash_featured_prp_open_dao"
    case dashFeaturedPrpOpenPrp = "dash_featured_prp_open_prp"
    // Followed DAOs with active vote
    case dashFollowedDaoActiveVoteOpenDao = "dash_followed_av_open_dao"
    // Vote Now
    case dashVoteNowOpenDao = "dash_vote_now_open_dao"
    case dashVoteNowOpenPrp = "dash_vote_now_open_prp"
    case screenDashVoteNowList = "screen_vote_now_list"
    case dashVoteNowPrpFromList = "dash_vote_now_open_prp_from_list"
    case dashVoteNowDaoFromList = "dash_vote_now_open_dao_from_list"
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
    case inboxEventAddReminder = "inbox_event_add_reminder"

    // MARK: - Archive
    case screenArchive = "screen_archive"
    case screenArchiveEmpty = "screen_archive_empty"
    case archiveEventOpen = "archive_event_open"
    case archiveEventOpenDao = "archive_event_open_dao"
    case archiveEventUnarchive = "archive_event_unarchive"
    case archiveEventMarkRead = "archive_event_mark_read"
    case archiveEventMarkUnread = "archive_event_mark_unread"

    // MARK: - DAO Info
    case daoFollow = "dao_follow"
    
    // - Events
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
    case screenDaoInsightsTopVoters = "screen_dao_insights_top_voters"
    
    // MARK: - Delegates
    case screenDelegates = "screen_delegates"
    case dlgActionFromDelegatesList = "dlg_action_from_delegates_list"
    // - Full List
    case screenDelegatesFull = "screen_delegates_full"
    case dlgActionFromDelegatesListFull = "dlg_action_from_delegates_list_full"
    // - Profile
    case screenDelegateProfile = "screen_delegate_profile"
    case dlgActionFromDelegateProfile = "dlg_action_from_delegate_profile"
    case delegateProfileOpenProposal = "delegate_profile_open_proposal"
    case delegateProfileOpenDao = "delegate_profile_open_dao"
    case screenDelegateProfileAbout = "screen_delegate_profile_about"
    case screenDelegateProfileInfo = "screen_delegate_profile_info"
    // - Action
    case screenSplitDelegationAction = "screen_split_dlg_action"
    case dlgActionPending = "dlg_action_pending"
    case dlgActionSuccess = "dlg_action_success"
    case dlgActionFailed = "dlg_action_failed"

    // MARK: - Snapshot Proposal
    case screenSnpDetails = "screen_snp_details"
    case snpDetailsOpenOnSnanpshot = "snp_details_open_on_snanpshot"
    case snpDetailsAddReminder = "snp_details_add_reminder"
    case snpDetailsShowDao = "snp_details_show_dao"
    case snpDetailsShowUserProfile = "snp_details_show_user_profile"
    case snpDetailsVotesShowUserProfile = "snp_details_votes_show_user_profile"
    case snpDetailsShowFullDscr = "snp_details_show_full_dscr"
    case snpDetailsVote = "snp_details_vote"
    case snpDetailsViewSummary = "snp_details_view_summary"

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
    case snpVoteShowRateApp = "snp_vote_show_rate_app"

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
    case tapOnProfileImage = "tap_on_profile_image"
    case openEnsHelpArticle = "open_ens_help_article"
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

    // MARK: - Public Profile
    case screenPublicProfile = "screen_public_profile"

    // Voted In DAOs
    case publicPrfVotedDaoOpen = "public_prf_voted_dao_open"
    case screenPublicPrfDaoFull = "screen_public_prf_dao_full"
    case publicPrfDaoFullOpenDao = "public_prf_dao_full_open_dao"
    case publicPrfDaoFullFollow = "public_prf_dao_full_follow"
    case publicPrfDaoFullUnfollow = "public_prf_dao_full_unfollow"

    // Votes
    case publicPrfVotesOpenProposal = "public_prf_votes_open_proposal"
    case publicPrfVotesOpenDao = "public_prf_votes_open_dao"
    case screenPublicProfileVotesFull = "screen_public_profile_votes_full"
    case publicPrfVotesFullOpenProposal = "public_prf_votes_full_open_prp"
    case publicPrfVotesFullOpenDao = "public_prf_votes_full_open_dao"

    // MARK: - DAOs Recommendation
    case screenDaosRecommendation = "screen_daos_recommendation"
    case daosRecommendationOpenDao = "daos_recommendation_open_dao"
    case daosRecommendationFollow = "daos_recommendation_follow"

    // MARK: - Settings
    case screenSettings = "screen_settings"
    case settingsOpenX = "settings_open_X"
    case settingsOpenDiscord = "settings_open_discord"
    case settingsOpenEmail = "settings_open_email"
    case settingsOpenWarpcast = "settings_open_warpcast"
    case settingsOpenLens = "settings_open_lens"
    case settingsOpenOrb = "settings_open_orb"
    case settingsOpenHey = "settings_open_hey"

    // Push Notifications
    case screenNotifications = "screen_notifications"
    case settingsEnableGlbNotifications = "settings_enable_glb_notifications"
    case settingsDisableGlbNotifications = "settings_disable_glb_notifications"
    case settingsSetCustomNtfDetails = "settings_set_custom_ntf_details"

    // Inbox Notifications
    case screenInboxNotifications = "screen_inbox_notifications"
    case settingsInboxSetCustomNtf = "settings_inbox_set_custom_ntf"

    // About
    case screenAbout = "screen_about"
    case settingsOpenPrivacyPolicy = "settings_open_privacy_policy"
    case settingsOpenTerms = "settings_open_terms"

    // Help Us Grow
    case screenHelpUsGrow = "screen_help_us_grow"
    case settingsRateTheApp = "settings_rate_the_app"
    case settingsShareXPost = "settings_share_X_post"
    case settingsShareWarpcastPost = "settings_share_warpcast_post"

    // Advanced
    case screenAdvancedSettings = "screen_advanced_settings"
    case settingsDisableTracking = "settings_disable_tracking"
    
    // MARK: - App Update
    case screenAppUpdateBlockScreen = "screen_force_update"
    case appUpdateScreenOpenAppStoreLink = "force_update_open_app_store_link"
    case appUpdateScreenOpenDiscordLink = "force_update_open_discord_link"
    
    // MARK: - Server Maintenance
    case screenMaintenance = "screen_maintenance"
    case maintenanceScreenOpenX = "maintenance_open_X"
    case maintenanceScreenOpenDiscord = "maintenance_open_discord"

    // MARK: - Push Notifications
    case openPush = "open_push"
}
