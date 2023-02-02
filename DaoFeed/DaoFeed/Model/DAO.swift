//
//  DAO.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI

struct DAO: Identifiable, Decodable {
    let id: UUID
    let name: String
    let image: URL?
    
    init(id: UUID, name: String, image: URL?) {
        self.id = id
        self.name = name
        self.image = image
    }
}

struct DAOsGroup: Identifiable, Decodable {
    let id: UUID
    let groupType: daosGroupType
    let daos: [DAO]
    
    init(id: UUID, groupType: daosGroupType, daos: [DAO]) {
        self.id = id
        self.groupType = groupType
        self.daos = daos
    }
}

enum daosGroupType: String, Decodable {
    case social
    case `protocol`
    case investment
    case creator
    case service
    case collector
    case media
    case grant
}
