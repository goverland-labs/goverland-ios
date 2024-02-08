//
//  LogInfoTrackingHandler.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

final class LogInfoTrackingHandler: TrackingHandler {
    private var trackingEnabled = true

    func track(event: String, parameters: [String: Any]?) {
        guard trackingEnabled else { return }
        let parametersString = parameters != nil ? (", parameters: " + String(describing: parameters!)) : ""
        logInfo("[TRACKING] event: \(event) \(parametersString)")
    }

    func setUserProperty(_ value: String, for property: UserProperty) {
        guard trackingEnabled else { return }
        logInfo("[TRACKING] setUserProperty: '\(value)' for \(property.rawValue)")
    }

    func setTrackingEnabled(_ value: Bool) {
        trackingEnabled = value
    }
}
