//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    @Published var followedDaos: [Dao] = []
    @Published var noFollowedDaoFound: Bool = false
    @Published var failToStartFollowing: Bool = false
    
    private(set) var totalFollowedDaos: Int?
    private var cancellables = Set<AnyCancellable>()
    

}
