//
//  CrashlyticsLogHandler.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import FirebaseCrashlytics

class CrashlyticsLogHandler: LogHandler {
    func logInfo(_ message: String) {
        // do nothing
    }
    
    func logError(_ error: Error, file: StaticString, line: UInt, function: StaticString) {
        let filePath = "\(file)"
        let fileName = (filePath as NSString).lastPathComponent
        let description = (error as? GError)?.localizedDescription ?? error.localizedDescription
        let msg = "[ERROR] \(fileName): \(line): \(function) \(description)"

        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("Non-fatal error.", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("\(msg)", comment: "")
        ]
        Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
    }
}
