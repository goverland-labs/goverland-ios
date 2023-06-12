//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowedDaoDataSource: ObservableObject {
    @Published var followedDaos: [Dao] = []
    @Published var noFollowedDaoFound: Bool = false
    private(set) var totalFollowedDaos: Int?
    private var cancellables = Set<AnyCancellable>()
    
    func loadFollowedDaosData() {
        APIService.getFollowedDaoList()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.noFollowedDaoFound = true
                }
            } receiveValue: { [weak self] result, headers in
                    print(result)
                self?.followedDaos = result
        
                guard let totalStr = headers["x-total-count"] as? String,
                    let total = Int(totalStr) else {
                    // TODO: log in crashlytics
                    return
                }
                self?.totalFollowedDaos = total
            }
            .store(in: &cancellables)
    }
}
