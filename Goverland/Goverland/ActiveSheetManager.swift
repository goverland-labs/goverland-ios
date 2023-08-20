//
//  ActiveSheetManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 06.07.23.
//

import Foundation

enum ActiveSheet: Identifiable {
    case daoInfo(Dao)
    case followDaos
    case signIn

    var id: Int {
        switch self {
        case .daoInfo: return 1
        case .followDaos: return 2
        case .signIn: return 3
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
