//
//  DaoDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import Foundation

class DaoDataSource {
    let category: DaoCategory?
    var daos: [Dao]

    init(category: DaoCategory?) {
        self.category = category
        self.daos = [.aave, .gnosis]
    }
}
