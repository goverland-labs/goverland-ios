//
//  Tracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import SwiftUI

protocol TrackingHandler: AnyObject {
    func track(event: String, parameters: [String: Any]?)
}

class Tracker {
    fileprivate static let shared = Tracker()
    private var trackingHandlers = [TrackingHandler]()
    @Setting(\.termsAccepted) var termsAccepted

    fileprivate func append(handler: TrackingHandler) {
        guard !trackingHandlers.contains(where: { $0 === handler }) else { return }
        trackingHandlers.append(handler)
    }

    fileprivate func track(event: Trackable, parameters: [String: Any]? = nil) {
        if termsAccepted {
            for handler in trackingHandlers {
                handler.track(event: event.eventName, parameters: parameters)
            }
        }
    }

    fileprivate func setTrackingEnabled(_ value: Bool) {
        termsAccepted = value
    }
}

extension Tracker {
    static func track(_ event: TrackingEvent, parameters: [String: Any]? = nil) {
        Tracker.shared.track(event: event, parameters: parameters)
    }

    static func append(handler: TrackingHandler) {
        Tracker.shared.append(handler: handler)
    }

    static func setTrackingEnabled(_ value: Bool) {
        Tracker.shared.setTrackingEnabled(value)
    }
}
