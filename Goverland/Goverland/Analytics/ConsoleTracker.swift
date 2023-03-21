//
//  ConsoleTracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import Foundation
import LoggingKit

final class ConsoleTracker: TrackingHandler {
    private var trackingEnabled = true

    /// You will find the events by the "[TRACKING]" tag in the log.
    func track(event: String, parameters: [String: Any]?, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        guard trackingEnabled else { return }
        let parametersString = parameters != nil ? (", parameters: " + String(describing: parameters!)) : ""
        LogService.shared.info("[TRACKING] event: '\(event)'" + parametersString, file: file, line: line, function: function)
    }

    func setUserProperty(_ value: String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        guard trackingEnabled else { return }
        LogService.shared.info("[TRACKING] setUserProperty: '\(value)' for \(property.rawValue)", file: file, line: line, function: function)
    }

    func setTrackingEnabled(_ value: Bool) {
        trackingEnabled = value
    }
}
