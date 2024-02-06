//
//  SystemLogHandler.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 02.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import OSLog

class SystemLogHandler: LogHandler {
    let logger = Logger()

    func logInfo(_ message: String) {
        logger.info("\(message)")
    }
    
    func logError(_ error: Error, file: StaticString, line: UInt, function: StaticString) {
        let filePath = "\(file)"
        let fileName = (filePath as NSString).lastPathComponent
        let description = (error as? GError)?.localizedDescription ?? error.localizedDescription
        let msg = "[ERROR] \(fileName): \(line): \(function) \(description)"
        logger.error("\(msg)")
    }
}
