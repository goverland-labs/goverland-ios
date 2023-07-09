//
//  ConsoleTracker.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import Foundation
import OSLog

final class ConsoleTracker: TrackingHandler {
    let logger = Logger()

    func track(event: String, parameters: [String: Any]?) {
        let parametersString = parameters != nil ? (", parameters: " + String(describing: parameters!)) : ""
        logger.log("[TRACKING] event: \(event) \(parametersString)")
    }
}
