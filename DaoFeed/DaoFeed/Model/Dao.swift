//
//  Dao.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI

struct Dao: Identifiable, Decodable {
    let id: UUID
    let name: String
    let image: URL?
    
    init(id: UUID, name: String, image: URL?) {
        self.id = id
        self.name = name
        self.image = image
    }
}

struct DaoGroup: Identifiable, Decodable {
    let id: UUID
    let groupType: DaoGroupType
    let daos: [Dao]
    
    init(id: UUID, groupType: DaoGroupType, daos: [Dao]) {
        self.id = id
        self.groupType = groupType
        self.daos = daos
    }
}

enum DaoGroupType: String, Decodable {
    case social
    case `protocol`
    case investment
    case creator
    case service
    case collector
    case media
    case grant
}
