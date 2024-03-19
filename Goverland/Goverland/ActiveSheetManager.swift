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
    case publicProfile(Address)
    case allDaoVoters(Dao)
    case followDaos
    case archive
    case subscribeToNotifications
    case recommendedDaos([Dao])

    var id: Int {
        switch self {
        case .signIn: return 0
        case .daoInfo: return 1
        case .publicProfile: return 2
        case .allDaoVoters: return 3
        case .followDaos: return 4
        case .archive: return 5
        case .subscribeToNotifications: return 6
        case .recommendedDaos: return 7
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
