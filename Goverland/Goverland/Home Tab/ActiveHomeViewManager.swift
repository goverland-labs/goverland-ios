//
//  ActiveHomeViewManager.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import Foundation

enum HomeActiveView: Int, Identifiable {
    case dashboard = 0
    case inbox

    var id: Int { self.rawValue }
}

class ActiveHomeViewManager: ObservableObject {
    @Published var activeView = HomeActiveView.dashboard

    static let shared = ActiveHomeViewManager()

    private init() {}
}
