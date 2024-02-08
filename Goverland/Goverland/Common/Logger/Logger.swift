//
//  Logger.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-02.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

func logInfo(_ message: String) {
    GLogger.shared.logInfo(message)
}

func logError(_ error: Error, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    GLogger.shared.logError(error, file: file, line: line, function: function)
}

protocol LogHandler: AnyObject {
    func logInfo(_ message: String)
    func logError(_ error: Error, file: StaticString, line: UInt, function: StaticString)
}

class GLogger {
    fileprivate static let shared = GLogger()
    private var handlers = [LogHandler]()

    private init() {}

    static func append(handler: LogHandler) {
        GLogger.shared.append(handler: handler)
    }

    private func append(handler: LogHandler) {
        guard !handlers.contains(where: { $0 === handler }) else { return }
        handlers.append(handler)
    }

    fileprivate func logInfo(_ message: String) {
        for handler in handlers {
            handler.logInfo(message)
        }
    }

    fileprivate func logError(_ error: Error, file: StaticString, line: UInt, function: StaticString) {
        for handler in handlers {
            handler.logError(error, file: file, line: line, function: function)
        }
    }
}
