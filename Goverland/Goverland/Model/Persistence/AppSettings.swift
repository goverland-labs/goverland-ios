//
//  Schema.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.11.23.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData

@Model
final class AppSettings {
    var termsAccepted: Bool
    private(set) var trackingAccepted: Bool

    init(termsAccepted: Bool = false,
         trackingAccepted: Bool = false) {
        self.termsAccepted = termsAccepted
        self.trackingAccepted = trackingAccepted
    }
}

extension AppSettings {
    func setTrackingAccepted(_ accepted: Bool) {
        self.trackingAccepted = accepted
        Tracker.setTrackingEnabled(accepted)
    }

    func reset() {
        termsAccepted = false
        setTrackingAccepted(false)        
    }
}
