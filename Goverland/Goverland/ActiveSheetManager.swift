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
    case daoInfoById(String)
    case publicProfileById(String)
    case daoVoters(Dao, DatesFiltetingOption)
    case proposalVoters(Proposal)
    case followDaos
    case notifications
    case archive
    case subscribeToNotifications
    case recommendedDaos([Dao])
    case daoDelegateProfileById(daoId: String, delegateId: String, delegateAction: DelegateAction)
    case daoUserDelegate(Dao, User)
    case proposal(String)

    var id: Int {
        switch self {
        case .signIn: return 0
        case .daoInfoById: return 1
        case .publicProfileById: return 2
        case .daoVoters: return 3
        case .proposalVoters: return 4
        case .followDaos: return 5
        case .notifications: return 6
        case .archive: return 7
        case .subscribeToNotifications: return 8
        case .recommendedDaos: return 9
        case .daoDelegateProfileById: return 10
        case .daoUserDelegate: return 11
        case .proposal: return 12
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
