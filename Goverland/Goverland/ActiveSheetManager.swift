//
//  ActiveSheetManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 06.07.23.
//  Copyright © Goverland Inc. All rights reserved.
//

import Foundation

enum ActiveSheet: Identifiable, Equatable {
    case signIn
    case daoInfo(Dao)
    case followDaos
    case archive
    case subscribeToNotifications

    var id: Int {
        switch self {
        case .signIn: return 0
        case .daoInfo: return 1
        case .followDaos: return 2
        case .archive: return 3
        case .subscribeToNotifications: return 4
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
