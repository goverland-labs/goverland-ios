//
//  Tracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI

protocol TrackingHandler: AnyObject {
    func track(event: String, parameters: [String: Any]?)
    func setTrackingEnabled(_ value: Bool)
    func setUserProperty(_ value: String, for property: UserProperty)
}

protocol UserProperty {    
    var rawValue: String { get }
}

class Tracker {
    fileprivate static let shared = Tracker()
    private var trackingHandlers = [TrackingHandler]()

    private init() {}

    fileprivate func append(handler: TrackingHandler) {
        guard !trackingHandlers.contains(where: { $0 === handler }) else { return }
        trackingHandlers.append(handler)
    }

    fileprivate func track(event: Trackable, parameters: [String: Any]? = nil) {
        for handler in trackingHandlers {
            handler.track(event: event.eventName, parameters: parameters)
        }        
    }

    fileprivate func setUserProperty(_ value: String, for property: UserProperty) {
        for handler in trackingHandlers {
            handler.setUserProperty(value, for: property)
        }
    }

    fileprivate func setTrackingEnabled(_ value: Bool) {
        for handler in trackingHandlers {
            handler.setTrackingEnabled(value)
        }
    }
}

extension Tracker {
    static func track(_ event: TrackingEvent, parameters: [String: Any]? = nil) {
        Tracker.shared.track(event: event, parameters: parameters)
    }

    static func append(handler: TrackingHandler) {
        Tracker.shared.append(handler: handler)
    }

    static func setUserProperty(_ value: String, for property: UserProperty) {
        Tracker.shared.setUserProperty(value, for: property)
    }

    static func setTrackingEnabled(_ value: Bool) {
        Tracker.shared.setTrackingEnabled(value)
    }
}
