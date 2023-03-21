//
//  TrackingHandler.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-20.
//

import SwiftUI

protocol TrackingHandler: AnyObject {
    
    /// Track event with parameters.
    /// - Parameters:
    ///   - event: occurred event
    ///   - parameters: optional parameters
    ///   - file: file name this was called from. Usually #file
    ///   - line: line in file this was called from. Usually #line
    ///   - function: function anme this was called from. Usually #function
    func track(event: String, parameters: [String: Any]?, file: StaticString, line: UInt, function: StaticString)

    /// Specifies if tracking should be enabled for tracking handler
    /// - Parameter value: Bool value to indicate if tracking should be enabled
    func setTrackingEnabled(_ value: Bool)
}

/// Conform your enum to this protocol for it to be tracked with Tracker.
protocol Trackable {
    // Raw value of the enum (String)
    var rawValue: String { get }
    // Event type for tracking. Default value is `rawValue`
    var eventName: String { get }
    // Parameters to supply with the event. Default value is `nil`.
    var parameters: [String: Any]? { get }
}

extension Trackable {
    var eventName: String { return rawValue }
    var parameters: [String: Any]? { return nil }
}
