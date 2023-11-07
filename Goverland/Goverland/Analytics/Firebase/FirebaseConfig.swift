//
//  FirebaseConfig.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation
import Firebase

class FirebaseConfig {
    static func setUp() {
        dispatchPrecondition(condition: .onQueue(.main))
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            logInfo("[WARNING] Firebase config file is not found. Firebase is disabled.")
            return
        }
        FirebaseApp.configure()
    }
}
