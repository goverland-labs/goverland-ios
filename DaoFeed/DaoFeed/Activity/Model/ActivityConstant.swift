//
//  Constant.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

enum ActivityListItemType {
    case vote
    case discussion
    case undefined
}

enum ActivityListItemStatus {
    case discussion
    case activeVote
    case executed
    case failed
    case queued
    case succeeded
    case defeated
}
