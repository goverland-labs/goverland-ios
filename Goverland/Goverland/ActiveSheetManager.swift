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
        case .publicProfile: return 2
        case .daoVoters: return 3
        case .proposalVoters: return 4
        case .followDaos: return 5
        case .archive: return 6
        case .subscribeToNotifications: return 7
        case .recommendedDaos: return 8
        case .proposal: return 9
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
