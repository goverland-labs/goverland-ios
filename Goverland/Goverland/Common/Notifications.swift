//
//  Notifications.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 21.06.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let subscriptionDidToggle = Notification.Name("SubsciptionDidToggle")
    static let eventUnarchived = Notification.Name("EventUnarchived")
    static let wcSessionUpdated = Notification.Name("WC_SessionUpdated")
}
