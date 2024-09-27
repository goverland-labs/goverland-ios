//
//  Notifications.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 21.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let appEnteredForeground = Notification.Name("AppEnteredForeground")
    static let authTokenChanged = Notification.Name("AuthTokenChanged")
    static let unauthorizedActionAttempt = Notification.Name("UnauthorizedActionAttempt")
    static let subscriptionDidToggle = Notification.Name("SubsciptionDidToggle")
    static let eventUnarchived = Notification.Name("EventUnarchived")
    static let wcSessionUpdated = Notification.Name("WC_SessionUpdated")
    static let cbWalletAccountUpdated = Notification.Name("CoinbaseWalletAccountUpdated")
    static let voteCasted = Notification.Name("VoteCasted")
    static let proposalPushOpened = Notification.Name("ProposalPushOpened")
    static let delegated = Notification.Name("Delegated")
}
