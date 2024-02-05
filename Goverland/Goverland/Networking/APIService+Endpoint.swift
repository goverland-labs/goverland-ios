//
//  APIService+Endpoint.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 05.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import Combine

extension APIService {
    // MARK: - Auth

    static func guestAuth(guestId: String, deviceName: String, defaultErrorDisplay: Bool) -> AnyPublisher<(GuestAuthTokenEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = GuestAuthTokenEndpoint(guestId: guestId, deviceName: deviceName)
        logInfo("Guest ID: \(guestId)")
        return shared.request(endpoint, defaultErrorDisplay: defaultErrorDisplay)
    }

    static func regularAuth(address: String,
                            deviceId: String,
                            deviceName: String,
                            message: String,
                            signature: String) -> AnyPublisher<(RegularAuthTokenEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = RegularAuthTokenEndpoint(address: address,
                                                deviceId: deviceId,
                                                deviceName: deviceName,
                                                message: message,
                                                signature: signature)
        return shared.request(endpoint)
    }

    // MARK: - Profile

    static func profile() -> AnyPublisher<(ProfileEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProfileEndpoint()
        return shared.request(endpoint)
    }

    static func profileVotes(offset: Int = 0,
                             limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(ProfileVotesEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = ProfileVotesEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func signOut(sessionId: String) -> AnyPublisher<(SignOutEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = SignOutEndpoint(sessionId: sessionId)
        return shared.request(endpoint)
    }

    static func deleteProfile() -> AnyPublisher<(DeleteProfileEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DeleteProfileEndpoint()
        return shared.request(endpoint)
    }

    static func profileHasVotingPower(offset: Int = 0,
                                      limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(ProfileHasVotingPowerEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = ProfileHasVotingPowerEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    // MARK: - DAOs

    static func daos(offset: Int = 0,
                     limit: Int = ConfigurationManager.defaultPaginationCount,
                     sorting: DaoSorting = .default,
                     category: DaoCategory? = nil,
                     query: String? = nil) -> AnyPublisher<(DaoListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "sorting", value: "\(sorting)")
        ]
        if let category = category {
            queryParameters.append(URLQueryItem(name: "category", value: category.rawValue))
        }
        if let query = query {
            queryParameters.append(URLQueryItem(name: "query", value: query))
        }
        let endpoint = DaoListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func daosWithActiveVote() -> AnyPublisher<(DaoListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "followed", value: "true"),
            URLQueryItem(name: "activeVote", value: "true"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "limit", value: "100")
        ]
        let endpoint = DaoListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func topDaos() -> AnyPublisher<(DaoTopEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoTopEndpoint()
        return shared.request(endpoint)
    }

    static func daoInfo(id: UUID) -> AnyPublisher<(DaoInfoEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoInfoEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    // MARK: DAO Analytics

    static func monthlyActiveUsers(id: UUID) -> AnyPublisher<(DaoMonthlyActiveUsersEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoMonthlyActiveUsersEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    static func userBuckets(id: UUID, groups: String) -> AnyPublisher<(DaoUserBucketsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "groups", value: groups)
        ]
        let endpoint = DaoUserBucketsEndpoint(daoID: id, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func exclusiveVoters(id: UUID) -> AnyPublisher<(DaoExclusiveVotersEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DaoExclusiveVotersEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    static func successfulProposals(id: UUID) -> AnyPublisher<(SuccessfulProposalsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = SuccessfulProposalsEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    static func monthlyNewProposals(id: UUID) -> AnyPublisher<(MonthlyNewProposalsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MonthlyNewProposalsEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    static func mutualDaos(id: UUID,
                           limit: Int = 21) -> AnyPublisher<(MutualDaosEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = MutualDaosEndpoint(daoID: id, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func monthlyTotalDaos() -> AnyPublisher<(MonthlyTotalDaosEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MonthlyTotalDaosEndpoint()
        return shared.request(endpoint)
    }

    static func monthlyTotalVoters() -> AnyPublisher<(MonthlyTotalVotersEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MonthlyTotalVotersEndpoint()
        return shared.request(endpoint)
    }

    static func monthlyTotalNewProposals() -> AnyPublisher<(MonthlyTotalNewProposalsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MonthlyTotalNewProposalsEndpoint()
        return shared.request(endpoint)
    }

    // MARK: - Subscriptions

    static func subscriptions(offset: Int = 0,
                              limit: Int = 1000,
                              sorting: DaoSorting = .default) -> AnyPublisher<(SubscriptionsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "sorting", value: "\(sorting)")
        ]
        let endpoint = SubscriptionsEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func createSubscription(id: UUID) -> AnyPublisher<(CreateSubscriptionEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = CreateSubscriptionEndpoint(daoID: id)
        return shared.request(endpoint)
    }

    static func deleteSubscription(id: UUID) -> AnyPublisher<(DeleteSubscriptionEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DeleteSubscriptionEndpoint(subscriptionID: id)
        return shared.request(endpoint)
    }

    // MARK: - Proposals

    static func topProposals(offset: Int = 0,
                             limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(TopProposalsListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = TopProposalsListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func proposals(offset: Int = 0,
                          limit: Int = ConfigurationManager.defaultPaginationCount,
                          query: String? = nil) -> AnyPublisher<(ProposalsListEndpoint.ResponseType, HttpHeaders), APIError> {
        var queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if let query = query {
            queryParameters.append(URLQueryItem(name: "query", value: query))
        }
        let endpoint = ProposalsListEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func proposal(id: UUID) -> AnyPublisher<(ProposalEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProposalEndpoint(proposalID: id)
        return shared.request(endpoint)
    }

    // MARK: - Voting & Votes

    static func votes<ChoiceType: Decodable>(proposalID: String,
                                             offset: Int = 0,
                                             limit: Int = ConfigurationManager.defaultPaginationCount,
                                             query: String? = nil) -> AnyPublisher<(ProposalVotesEndpoint<ChoiceType>.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        let endpoint = ProposalVotesEndpoint<ChoiceType>(proposalID: proposalID, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func validate(proposalID: String, voter: String) -> AnyPublisher<(ProposalValidateAddressEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProposalValidateAddressEndpoint(proposalID: proposalID, voter: voter)
        return shared.request(endpoint)
    }

    static func prepareVote(proposal: Proposal,
                            voter: String,
                            choice: AnyObject,
                            reason: String?) -> AnyPublisher<(ProposalPrepareVoteEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProposalPrepareVoteEndpoint(proposal: proposal, voter: voter, choice: choice, reason: reason)
        return shared.request(endpoint)
    }

    static func submitVote(id: UUID,
                           signature: String) -> AnyPublisher<(ProposalSubmitVoteEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = ProposalSubmitVoteEndpoint(id: id, signature: signature)
        return shared.request(endpoint)
    }

    // MARK: - Feed

    static func inboxEvents(offset: Int = 0,
                            limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(InboxEventsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = InboxEventsEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func recentlyViewedDaos() -> AnyPublisher<(RecentlyViewedDaosEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = RecentlyViewedDaosEndpoint()
        return shared.request(endpoint)
    }

    static func ecosystemCharts(days: Int) -> AnyPublisher<(EcosystemDashboardChartsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = EcosystemDashboardChartsEndpoint(days: days)
        return shared.request(endpoint)
    }

    static func archivedEvents(offset: Int = 0,
                               limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(InboxEventsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "archived", value: "only")

        ]
        let endpoint = InboxEventsEndpoint(queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func daoEvents(daoID: UUID,
                          offset: Int = 0,
                          limit: Int = ConfigurationManager.defaultPaginationCount) -> AnyPublisher<(DaoEventsEndpoint.ResponseType, HttpHeaders), APIError> {
        let queryParameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let endpoint = DaoEventsEndpoint(daoID: daoID, queryParameters: queryParameters)
        return shared.request(endpoint)
    }

    static func markEventRead(eventID: UUID) -> AnyPublisher<(MarkEventReadEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventReadEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    static func markEventUnread(eventID: UUID) -> AnyPublisher<(MarkEventUnreadEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventUnreadEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    static func markAllEventsRead(before date: Date) -> AnyPublisher<(MarkAllEventsReadEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkAllEventsReadEndpoint(before: date)
        return shared.request(endpoint)
    }

    static func markEventArchived(eventID: UUID) -> AnyPublisher<(MarkEventArchivedEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventArchivedEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    static func markEventUnarchived(eventID: UUID) -> AnyPublisher<(MarkEventUnarchivedEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = MarkEventUnarchivedEndpoint(eventID: eventID)
        return shared.request(endpoint)
    }

    // MARK: - Notifications

    // TODO: atm this is not used. We will use it once we have granular notifications control
    static func notificationsSettings() -> AnyPublisher<(NotificationsSettingsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = NotificationsSettingsEndpoint()
        return shared.request(endpoint)
    }

    static func enableNotifications(_ token: String, defaultErrorDisplay: Bool) -> AnyPublisher<(EnableNotificationsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = EnableNotificationsEndpoint(token: token)
        return shared.request(endpoint, defaultErrorDisplay: defaultErrorDisplay)
    }

    static func disableNotifications() -> AnyPublisher<(DisableNotificationsEndpoint.ResponseType, HttpHeaders), APIError> {
        let endpoint = DisableNotificationsEndpoint()
        return shared.request(endpoint)
    }
}