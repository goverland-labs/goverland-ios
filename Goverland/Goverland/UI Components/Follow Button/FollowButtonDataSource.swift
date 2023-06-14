//
//  FollowButtonDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-06-12.
//

import Foundation
import Combine

class FollowButtonDataSource: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    var failToFollow: Bool = false

    
    func followDao(id: UUID) {
        APIService.followDao(id: id)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(_): self?.failToFollow = true
                }
            } receiveValue: { response, headers in
                print("------")
                print(response)
            }
            .store(in: &cancellables)
    }
}
