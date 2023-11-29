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

    init(termsAccepted: Bool) {
        self.termsAccepted = termsAccepted
    }
}
