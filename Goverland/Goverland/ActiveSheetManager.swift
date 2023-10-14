//
//  ActiveSheetManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 06.07.23.
//

import Foundation

enum ActiveSheet: Identifiable, Equatable {
    case daoInfo(Dao)
    case followDaos

    var id: Int {
        switch self {
        case .daoInfo: return 1
        case .followDaos: return 2
        }
    }
}

class ActiveSheetManager: ObservableObject {
    @Published var activeSheet: ActiveSheet?
}
