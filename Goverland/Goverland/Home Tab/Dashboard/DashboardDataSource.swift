//
//  DashboardDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 04.10.23.
//

import Foundation
import Combine

class DashboardViewDataSource: ObservableObject {
    @Published var randomNumber = Utils.randomNumber_8_dgts()

    static let shared = DashboardViewDataSource()

    private init() {}

    func refresh() {
        randomNumber = Utils.randomNumber_8_dgts()
    }
}
