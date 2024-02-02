//
//  ErrorLogger.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import FirebaseCrashlytics

func logError(_ error: Error, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    let filePath = "\(file)"
    let fileName = (filePath as NSString).lastPathComponent
    let description = (error as? GError)?.localizedDescription ?? error.localizedDescription
    let msg = "[ERROR] \(fileName): \(line): \(function) \(description)"
    logger.error("\(msg)")

    let userInfo = [
      NSLocalizedDescriptionKey: NSLocalizedString("Non-fatal error.", comment: ""),
      NSLocalizedFailureReasonErrorKey: NSLocalizedString("\(msg)", comment: "")
    ]
    Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
}
