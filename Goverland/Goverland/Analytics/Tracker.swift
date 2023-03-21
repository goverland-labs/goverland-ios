//
//  Tracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import SwiftUI

class Tracker {

    fileprivate static var shared = Tracker()
    private var trackingHandlers = [TrackingHandler]()

    func append(handler: TrackingHandler) {
        guard !trackingHandlers.contains(where: { $0 === handler }) else { return }
        trackingHandlers.append(handler)
    }

    func remove(handler: TrackingHandler) {
        if let handlerIndex = trackingHandlers.firstIndex(where: { $0 === handler }) {
            trackingHandlers.remove(at: handlerIndex)
        }
    }

    func track(event: Trackable, parameters: [String: Any]? = nil, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        var joinedParameters = event.parameters ?? [:]
        parameters?.forEach { joinedParameters[$0.key] = $0.value }
        let trackedParameters: [String: Any]? = joinedParameters.isEmpty ? nil : joinedParameters
        for handler in trackingHandlers {
            handler.track(event: event.eventName, parameters: trackedParameters, file: file, line: line, function: function)
        }
    }

    func setTrackingEnabled(_ value: Bool) {
        for handler in trackingHandlers {
            handler.setTrackingEnabled(value)
        }
    }
}
