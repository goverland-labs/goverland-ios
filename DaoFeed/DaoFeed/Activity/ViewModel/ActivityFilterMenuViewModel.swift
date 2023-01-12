//
//  ActivityFilterMenuViewModel.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct ActivityFilterMenuViewModel {
    
    func filteredActivityItems(type: ActivityEventType) -> [ActivityEvent] {
        let events = ActivityDataService.data.events
        switch type {
        case .discussion:
            return events.filter { $0.type == .discussion }
        case .vote:
            return events.filter { $0.type == .vote }
        case .undefined:
            return events.filter { $0.type == .undefined }
        }
    }
    
}


