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
    case daoInfoById(String)
    case publicProfileById(String)
    case daoVoters(Dao, DatesFiltetingOption)
    case proposalVoters(Proposal)
    case followDaos
    case archive
    case subscribeToNotifications
    case recommendedDaos([Dao])
    case proposal(String)

    var id: Int {
        switch self {
        case .signIn: return 0
        case .daoInfo: return 1
        case .daoInfoById: return 2
        case .publicProfileById: return 3
        case .daoVoters: return 4
        case .proposalVoters: return 5
        case .followDaos: return 6
        case .archive: return 7
        case .subscribeToNotifications: return 8
        case .recommendedDaos: return 9
        case .proposal: return 10
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
