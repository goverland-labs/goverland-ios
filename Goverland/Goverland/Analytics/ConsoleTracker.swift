//
//  ConsoleTracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import Foundation

final class ConsoleTracker: TrackingHandler {
    func track(event: String, parameters: [String: Any]?) {
        let parametersString = parameters != nil ? (", parameters: " + String(describing: parameters!)) : ""
        logInfo("[TRACKING] event: \(event) \(parametersString)")
    }
}
